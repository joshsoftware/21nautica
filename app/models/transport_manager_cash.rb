# Transport manger cash Model
class TransportManagerCash < ActiveRecord::Base
  validates :truck_id, :transaction_amount, presence: true, if: -> { transaction_type.include?('Withdrawal') }
  validate :cash_assigned?, :truck_allocated?, :file_ref_number_present?, if: -> { transaction_date.nil? }
  attr_accessor :file_ref_number, :truck_loaded_out_of_port
  before_save  :update_import_item_id, :update_import_id, if: -> { transaction_type.include?('Withdrawal') }
  before_create :update_sr_number, if: -> { transaction_type.include?('Withdrawal') }
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :import
  belongs_to :import_item
  belongs_to :truck
  before_save :update_transaction_date

  def find_import
    Import.find_by(work_order_number: file_ref_number)
  end

  def update_transaction_date
    self.transaction_date = Date.today if self.file_ref_number
  end
  
  def last_enrty_month
    TransportManagerCash.where('date >= ? ', Date.today.beginning_of_month)
                       .where.not(sr_number: nil).count
  end

  def update_sr_number
    self.sr_number = last_enrty_month + 1
  end

  def file_ref_number_present?
    check_import = Import.find_by(work_order_number: file_ref_number)
    if check_import.nil? && self.file_ref_number
      errors.add(:file_ref_number, 'Please enter valid file Number')
    end
    check_truck = check_import.import_items.find_by(truck_id: truck) if check_import
    if check_truck.nil? && self.file_ref_number
      errors.add(:truck_id, "Please select correct truck")
    end
  end

  def truck_allocated?
    truck = self.truck.import_items.truck_allocated.last
    if truck.nil? && self.file_ref_number.nil?
      errors.add(:truck_id, 'please select allocated truck')
    end
  end

  def update_import_item_id
    self.import_item_id = self.file_ref_number ? find_import.import_items.where(truck_id: truck.id).last.id : self.truck.import_items.truck_allocated.last.id 
  end

  def update_import_id
    self.import_id = self.file_ref_number ? find_import.id : truck.import_items.truck_allocated.last.import_id
  end

  def last_available_balance
    TransportManagerCash.last.try(:available_balance).to_f
  end

  def cash_assigned?
    if TransportManagerCash.find_by(truck_id: truck.id, transaction_date: nil) && self.file_ref_number.nil?
      errors.add(:truck_id, 'truck has already assigned cash')
    end
  end
  
  def self.last_balance
    TransportManagerCash.where(updated_at: TransportManagerCash.where.not(transaction_date: nil).maximum(:updated_at)).last.try(:available_balance).to_f
  end
  
end
