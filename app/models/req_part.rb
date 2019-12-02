class ReqPart < ActiveRecord::Base
  belongs_to :spare_part
  belongs_to :mechanic
  belongs_to :req_sheet
  after_create :adjust_ledger
  after_destroy :adjust_ledger

  validates_presence_of :mechanic_id, :spare_part_id, :price, :quantity

  def adjust_ledger
    SparePartLedger.adjust_whole_ledger(self.spare_part_id)
  end
end
