module BillsHelper

  def get_vendor
    Vendor.all.pluck(:name, :id)
  end

end
