namespace :assigns_bl_number_in_movements do

  desc "Assigns the Bl Number in Movements from Bill of Lading"
  task set_bl_number: :environment do 
    movements = Movement.where.not(bill_of_lading: nil)

    movements.each do |movement|
      movement.update_attribute(:bl_number, movement.bill_of_lading.bl_number)
    end
  end
end
