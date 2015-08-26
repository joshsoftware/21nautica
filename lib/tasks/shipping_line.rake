namespace :shipping_line do

  desc "Add Shipping line"
  task add_shipping_line_to_vendor: :environment do
     %W(CMA\ CGM Maersk  Evergreen Safmarine PIL Emirates MSC COSCONYK\ line WECLINES).each do |shipping_line|
       Vendor.create(name: shipping_line, vendor_type: "shipping_line")
     end
  end
end
