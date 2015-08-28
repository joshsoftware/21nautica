namespace :icd do

  desc "Add ICD"
  task add_icd_to_vendor: :environment do
     %W(Maina Multiple).each do |icd|
       Vendor.create(name: icd, vendor_type: "icd")
     end
  end
end
