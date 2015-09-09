module BillsHelper

  def get_vendor
    Vendor.all.map {|vendor| [ vendor.name, vendor.id, {"data-type" => vendor.vendor_type}] }
  end

  def item_for
    if @bill.new_record?
      []
    else
      @item_for
    end
  end

  def charges_vendors 
    if @bill.new_record?
      []
    else
      @charges
    end
  end

end
