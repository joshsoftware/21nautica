class SparePartLedger < ActiveRecord::Base
  belongs_to :receipt, polymorphic: :true
  belongs_to :spare_part
  validates_presence_of :date, :inward_outward, :quantity, :spare_part_id

  def update_ledger
    SparePartLedger.adjust_whole_ledger(self)
  end

  def self.adjust_balance(spare_part_id)# it will just adjust the balance
    balance = 0
    SparePartLedger.where(spare_part_id: spare_part_id).update_all(balance: 0)
    SparePartLedger.where(spare_part_id: spare_part_id).order(date: :asc, id: :asc).each do |ledger|
      if ledger.inward_outward == "inward"
        balance = balance + ledger.quantity
      elsif ledger.inward_outward == "outward"
        balance = balance - ledger.quantity
      end
      ledger.update_column(:balance, balance)
    end
  end

  def self.adjust_whole_ledger(spare_part_id)#it deletes and recreate ledger for spare part
    SparePartLedger.where(spare_part_id: spare_part_id).delete_all
    PurchaseOrderItem.joins("left join purchase_orders on purchase_orders.id = purchase_order_items.purchase_order_id")
      .where(spare_part_id: spare_part_id)
      .select("purchase_order_items.*, purchase_orders.date po_date")
      .order("purchase_orders.date ASC, id ASC").each do |poi|
        is_adjustment = poi.purchase_order_id.nil? ? true : false 
        SparePartLedger.create(spare_part_id: poi.spare_part_id, date: poi.try(:po_date) || poi.created_at,
          quantity: poi.quantity, receipt: poi.purchase_order, inward_outward: "inward",
          is_adjustment: is_adjustment)
    end
    ReqPart.joins("left join req_sheets on req_sheets.id = req_parts.req_sheet_id").where(spare_part_id: spare_part_id).order("req_sheets.date ASC, id ASC").each do |req_part|
        is_adjustment = req_part.req_sheet_id.nil? ? true : false 
        SparePartLedger.create(spare_part_id: req_part.spare_part_id,
          date: req_part.req_sheet.try(:date) || req_part.created_at, quantity: req_part.quantity,
          receipt: req_part.req_sheet, inward_outward: "outward", is_adjustment: is_adjustment)
    end
    SparePartLedger.adjust_balance(spare_part_id)
  end

  def adjust_physical_stock
    if inward_outward == "inward"
      PurchaseOrderItem.create(spare_part_id: spare_part_id, quantity: quantity)
    elsif inward_outward == "outward"
      ReqPart.create(spare_part_id: spare_part_id, quantity: quantity, price: 0, mechanic_id: 0)
    end
  end

  def self.remove_entry(receipt_type, receipt_id)
    spare_part_ledger = SparePartLedger.find_by(receipt_type: receipt_type, receipt_id: receipt_id)
    spare_part_ledger.destroy if spare_part_ledger
  end

  def self.add_entry(receipt_type, receipt_id)
    spare_part_ledger = SparePartLedger.find_by(receipt_type: receipt_type, receipt_id: receipt_id)
    spare_part_ledger.destroy if spare_part_ledger
  end

end
