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
  has_many :bill_items

  accepts_nested_attributes_for :bill_items

  validates_uniqueness_of :bill_number, scope: [:bill_number, :bill_date, :vendor_id]
  validates_presence_of :bill_number, :vendor_id, :bill_date, :value, :created_by

  before_validation :assigns_bill_items
  before_validation :assign_activity

  private 
  
  def assigns_bill_items
    self.bill_items.each do |bill_item|
      bill_item.update_attribute(:bill_date, self.bill_date)
      bill_item.update_attribute(:vendor_id, self.vendor_id)
    end
  end

  def assign_activity
    ### Activity Import/Export Needs to Added
  end

end
