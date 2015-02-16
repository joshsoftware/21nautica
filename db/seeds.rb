# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
%W(Mansons Farsham Panafrica Crown Panafrica\ Logistics Midland\ Hauliers Blue\ Jay).each do |transporter|
  Vendor.create!(name: transporter, vendor_type: "transporter")
end

%W(Panafrica EACL Agility).each do |agent_name|
  Vendor.create(name: agent_name, vendor_type: "clearing_agent")
end
