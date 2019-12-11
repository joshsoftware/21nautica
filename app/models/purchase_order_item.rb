class PurchaseOrderItem < ActiveRecord::Base
  belongs_to :truck
  belongs_to :spare_part
  belongs_to :purchase_order
  validates :price, :quantity, numericality: { greater_than: 0 }

  after_create :adjust_ledger
  after_destroy :adjust_ledger

  def adjust_ledger
    Rails.logger.info "calling callback in purchase order item for #{self.spare_part_id}"
    SparePartLedger.adjust_whole_ledger(self.spare_part_id)
  end  
end
