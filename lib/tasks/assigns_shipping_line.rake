namespace :assign_shipping_line do

  desc "Assings Shpping Line to Shipping Line Id(vendor) In Import"
  task assign_shipping_line_to_shipping_line_id_import: :environment do 
    import = Import.where(shipping_line_id: nil)
    vendor = Vendor.where(vendor_type: 'shipping_line')

    import.each do |import|
      vendor = Vendor.where(name: import.shipping_line_name, vendor_type: "shipping_line").first
      import.update_attribute(:shipping_line_id, vendor.id) 
    end
  end

  desc "Assings Shipping Line to Shipping Line Id(vendor) in Export"
  task assign_shipping_line_to_shipping_line_id_export: :environment do 
    export = Export.where(shipping_line_id: nil)
    vendor = Vendor.where(vendor_type: 'shipping_line')

    export.each do |export|
      vendor = Vendor.where(name: export.shipping_line_name, vendor_type: "shipping_line").first
      export.update_attribute(:shipping_line_id, vendor.id) 
    end
  end
end
