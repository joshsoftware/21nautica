class BillOfLading < ActiveRecord::Base
  validates_uniqueness_of :bl_number
end
