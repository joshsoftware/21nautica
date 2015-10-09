#
# == Schema Information
# Table name: customers
#
#  id            :integer      not null, primary key
#  bill_number   :text
#  bill_date     :datetime
#  vendor_id     :integer
#  value         :float
#  remark        :text
#  created_by    :integer
#  created_on    :datetime
#  approved_by   :integer
class Bill < ActiveRecord::Base
  attr_accessor :bill_items_total
  belongs_to :created_by, class_name: 'User'
  belongs_to :approved_by, class_name: 'User'
  belongs_to :vendor
  has_many :bill_items, dependent: :destroy
  has_many :debit_notes
  has_one :vendor_ledger, as: :voucher

  accepts_nested_attributes_for :bill_items, allow_destroy: true
  accepts_nested_attributes_for :debit_notes, allow_destroy: true

  validates_associated :bill_items

  validates_uniqueness_of :bill_number, scope: [:bill_number, :bill_date, :vendor_id]
  validates_presence_of :bill_number, :vendor_id, :bill_date, :value, :created_by

  after_save :create_bill_vendor_ledger
  after_save :set_vendor_ledger_date, if: [:bill_date_changed?, :currency_changed?]
  after_save :set_debit_note_currency

  def set_debit_note_currency
    self.debit_notes.each do |debit_note|
      debit_note.update_attributes(currency: currency)
    end 
  end

  def set_vendor_ledger_date
    self.debit_notes.each do |debit_note|
      debit_note.vendor_ledger.update_attributes(date: self.bill_date, currency: self.currency)
    end
  end

  def create_bill_vendor_ledger
    self.vendor_ledger.nil? ? self.create_vendor_ledger(vendor_id: vendor_id, amount: value, date: bill_date, currency: currency) : 
      vendor_ledger.update_attributes(vendor_id: vendor_id, date: bill_date, amount: value, currency: currency)
  end

end
