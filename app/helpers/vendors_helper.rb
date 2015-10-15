module VendorsHelper

  def selected_vendors(vendor)
    @vendor.vendor_type.split(',').map {|v| v.to_s } unless vendor.vendor_type.nil?
  end
end
