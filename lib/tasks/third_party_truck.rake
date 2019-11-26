namespace :third_party_truck do
  desc "Creating third party truck with ID-0 and setting other third party truck as inactive"
  task create: :environment do
    Truck.where(reg_number: "3rd Party Truck").update_all(is_active: false)
    Truck.create(reg_number: "3rd Party Truck", id: 0) unless Truck.first.id.zero?
    p "Third party truck has been created with id-0"
  end
end
