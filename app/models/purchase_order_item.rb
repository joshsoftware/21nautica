class PurchaseOrderItem < ActiveRecord::Base
  belongs_to :truck
  belongs_to :spare_part
  belongs_to :purchase_order

  validates_presence_of :price, :quantity

  after_create :adjust_ledger
  after_destroy :adjust_ledger

  def adjust_ledger
    SparePartLedger.adjust_whole_ledger(self.spare_part_id)
  end  
end
