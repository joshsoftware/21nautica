module BillsHelper

  def get_vendor
    Vendor.all.map {|vendor| [ vendor.name, vendor.id, {"data-type" => vendor.vendor_type}] }
  end

  def item_for
    @item_for  
  end

  def charges_vendors(bill_item) 
    @charges & CHARGES_CLASSIFICATION[bill_item.item_for].to_a
  end

end
