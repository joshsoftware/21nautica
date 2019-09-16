# == Schema Information
#
# Table name: import_items
#
#  id               :integer          not null, primary key
#  container_number :string(255)
#  trailer_number   :string(255)
#  tr_code          :string(255)
#  truck_number     :string(255)
#  current_location :string(255)
#  bond_direction   :string(255)
#  bond_number      :string(255)
#  status           :string(255)
#  import_id        :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class ImportItem < ActiveRecord::Base
  include AASM
  include EspinitaPatch
  include MovementsHelper
  include Remarkable

  belongs_to :import
  belongs_to :transporter, class_name: "Vendor", foreign_key: "vendor_id"
  belongs_to :icd, class_name: "Vendor"
  belongs_to :truck
  has_many :import_expenses, dependent: :destroy

  validate :assignment_of_truck_number, if: "truck_number.present? && truck_number_changed?"
  validates_presence_of :container_number
  validates_uniqueness_of :container_number
 
  delegate :bl_number, to: :import
  delegate :clearing_agent, to: :import, allow_nil: true

  accepts_nested_attributes_for :import_expenses

  before_save :add_default_date_for_remarks
  after_save :assign_current_import_item, if: :truck_id_changed?
  after_save :update_last_loading_date, if: :last_loading_date_changed?
  after_update :update_truck_status

  after_create do |record|
    ImportExpense::CATEGORIES.each do |category|
      record.import_expenses.create(category: category)
    end
  end

  def assignment_of_truck_number
    count = ImportItem.where(truck_number: truck_number).where.not(status: 'delivered').count
    if count > 0 && truck_number != nil
      errors.add(:truck_number," #{truck_number} is not free !")
    end
  end

  def customer_name
    import.customer.name
  end

  aasm column: 'status' do
    state :under_loading_process, initial: true
    state :truck_allocated
    state :loaded_out_of_port
    state :arrived_at_border
    state :departed_from_border
    state :arrived_at_destination
    state :delivered

    event :allocate_truck, :after => :check_rest_of_the_containers do
      transitions from: :under_loading_process, to: :truck_allocated
    end

    event :loaded_out_of_port, :after => [:create_rfs_invoice] do
      transitions from: :truck_allocated, to: :loaded_out_of_port, guard: :is_truck_number_assigned?
    end

    event :arrived_at_border do
      transitions from: :loaded_out_of_port, to: :arrived_at_border
    end

    event :departed_from_border do
      transitions from: :arrived_at_border, to: :departed_from_border
    end

    event :arrived_at_destination do
      transitions from: :departed_from_border, to: :arrived_at_destination
    end

    event :truck_released, :after => [:check_for_invoice, :set_delivery_date, :release_truck] do
      transitions from: :arrived_at_destination, to: :delivered
    end
  end

  auditable only: [:status, :updated_at, :current_location]

  def is_truck_number_assigned?
    return true if ENV['HOSTNAME'] != 'RFS'
    self.errors[:base] <<  'Add Truck Number first !' if truck.nil?
    !self.errors.present?
  end

  def release_truck
    self.truck.update_attributes(status: Truck::FREE, current_import_item_id: nil) if truck.present?
  end

  def set_delivery_date
    update_attribute(:close_date, Time.zone.now)
  end

  def transporter_name
    self.transporter.try(:name)
  end

  def transporter_name=(transporter_name)
    self.transporter = Vendor.where(name: transporter_name).first
  end

  def work_order_number
    self.import.work_order_number
  end

  def equipment_type
    self.import.equipment
  end

  def DT_RowId
    self.id
  end

  def formatted_close_date
    self.close_date.strftime("%Y-%m-%d") unless self.close_date.blank?
  end

  def delivery_date
    status_updated_at(self).strftime("%Y-%m-%d") unless status_updated_at(self).blank?
  end

  def rfs_truck_number
    truck && truck.reg_number
  end

  def as_json(options= {})
    super(only: [:container_number, :id, :after_delivery_status, :context, :truck_number, :status],
            methods: [:bl_number, :customer_name, :work_order_number, :truck_number, :rfs_truck_number,
              :equipment_type, :DT_RowId, :formatted_close_date, :delivery_date,
              :transporter_name, :clearing_agent, :edit_close_date_import_item_path])
  end

  def edit_close_date_import_item_path
    Rails.application.routes.url_helpers.edit_close_date_import_item_path(self)
  end

  def find_bill_of_lading
    BillOfLading.where(bl_number: self.bl_number).first
  end

  def find_all_containers_status
    import_items = ImportItem.where(import_id: self.import_id).pluck(:status)
  end

  def first_container_loaded_out_of_port_date
    import_items = ImportItem.where(import_id: self.import_id).pluck(:id)
    audits = Espinita::Audit.where(auditable_type: "ImportItem", auditable_id: import_items)
    loading_dates = []
    audits.each do |audit_entry|
       loading_dates.push(audit_entry.audited_changes[:updated_at].second) if (audit_entry[:audited_changes][:status] == ["truck_allocated", "loaded_out_of_port"])
    end
    loading_dates.min
  end

  def check_rest_of_the_containers
    bill_of_lading = self.find_bill_of_lading
    statuses = self.find_all_containers_status
    invoice = bill_of_lading.invoices.where(previous_invoice_id: nil).first
    invoice.invoice_ready! if (!statuses.include?("under_loading_process") && invoice.present?)
  end

  def create_rfs_invoice
    check_for_invoice if ENV['HOSTNAME'] == 'RFS' || ENV['HOSTNAME'] == 'ERP'
  end

  def check_for_invoice
    bill_of_lading = self.find_bill_of_lading
    invoice = bill_of_lading.invoices.where(previous_invoice_id: nil).first
    return if (invoice && (invoice.status.eql?("ready") || invoice.status.eql?("sent")) )
    if invoice.blank?
      date = self.first_container_loaded_out_of_port_date
      invoice = Invoice.create(date: date, customer_id: self.import.customer_id)
      invoice.invoiceable = bill_of_lading
      invoice.document_number = bill_of_lading.import.work_order_number
      invoice.save
    end
    statuses = self.find_all_containers_status
    invoice.invoice_ready! unless statuses.include?("under_loading_process")
  end

  def update_truck_status
    if changes['truck_id'] && changes['truck_id'][0]
      prev_truck = Truck.find(changes['truck_id'][0])
      prev_truck.update_column(:status, Truck::FREE)
    end
    self.truck.update_column(:status, Truck::ALLOTED) if self.truck && truck_id_changed?
  end

  def add_default_date_for_remarks
    return unless remarks.present?
    default_date = "#{Time.zone.now.strftime('%d/%m')} : "
    self.remarks = remarks.prepend(default_date)
  end

  def assign_current_import_item
    prev_truck_id, latest_truck_id = changes['truck_id']
    truck.update_column(:current_import_item_id, id) if latest_truck_id.present?
    if prev_truck_id.present?
      prev_truck = Truck.find(prev_truck_id)
      prev_truck.update_attributes(current_import_item_id: nil)
    end
  end

  def update_last_loading_date
    loading_date = self.last_loading_date
    import.import_items.update_all(last_loading_date: loading_date)
  end

end
