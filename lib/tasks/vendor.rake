namespace "vendor" do
  desc "Add Vendor id to each Movement"
  task add_to_movement: :environment do
    Movement.all.each do |movement|
      vendor_id = Vendor.where(name: movement.transporter_name).first.try(:id)
      movement.vendor_id= vendor_id
      movement.save!
    end
  end

  desc "Add Vendor id to each ImportItem"
  task add_to_import_item: :environment do
    ImportItem.all.each do |item|
      vendor_id = Vendor.where(name: item.transporter_name).first.try(:id)
      item.vendor_id= vendor_id
      item.save!
    end
  end
end