class SparePartLedger < ActiveRecord::Base
  belongs_to :receipt, polymorphic: :true
  belongs_to :spare_part

  def self.adjust_balance(spare_part_id)# it will just adjust the balance
    balance = 0
    SparePartLedger.where(spare_part_id: spare_part_id).update_all(balance: 0)
    SparePartLedger.where(spare_part_id: spare_part_id).order(date: :asc).each do |ledger|
      if ledger.inward_outward == "inward"
        balance = balance + ledger.quantity
      elsif ledger.inward_outward == "outward"
        balance = balance - ledger.quantity
      end
      ledger.update_column(:balance, balance)
    end
  end

  def self.adjust_whole_ledger(spare_part)#it deletes and recreate ledger for spare part
    SparePartLedger.where(spare_part_id: spare_part.id).delete_all
    PurchaseOrderItem.joins(:purchase_order).where(spare_part_id: spare_part.id)
      .select("purchase_order_items.*, purchase_orders.date po_date")
      .order("purchase_orders.date ASC").each do |poi|
        SparePartLedger.create(spare_part_id: poi.spare_part_id, date: poi.po_date,
          quantity: poi.quantity, receipt: poi.purchase_order, inward_outward: "inward",
          is_adjustment: false)
    end
    ReqPart.joins(:req_sheet).where(spare_part_id: spare_part.id).order("req_sheets.date ASC").each do |req_part|
        SparePartLedger.create(spare_part_id: req_part.spare_part_id,
          date: req_part.req_sheet.date, quantity: req_part.quantity,
          receipt: req_part.req_sheet, inward_outward: "outward", is_adjustment: false)
    end
    SparePartLedger.adjust_balance(spare_part.id)
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
