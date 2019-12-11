class PurchaseOrderItem < ActiveRecord::Base
  attr_accessor :is_adjustment
  belongs_to :truck
  belongs_to :spare_part
  belongs_to :purchase_order

  validates :price, :quantity, numericality: { greater_than: 0 }, unless: "is_adjustment.present?"

  after_create :adjust_ledger
  after_destroy :adjust_ledger

  def adjust_ledger
    SparePartLedger.adjust_whole_ledger(self.spare_part_id)
  end
end
