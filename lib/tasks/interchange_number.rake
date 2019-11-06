namespace :interchange_number do
  desc "Updating interchange number for old records as old interchange number as interchange number is newly added field"
  task update: :environment do
    p "Started to updating the interchange number for old records as old interchange number value"
    ImportItem.where(status: "delivered").update_all(interchange_number: "old interchange number")
    #The value can be change to "" if we need to show the interchnage number in UI.
    p "Interchange number is updated for old records"
  end
end
