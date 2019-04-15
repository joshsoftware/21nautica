namespace :yard do

  desc "Assign Truck current import"
  task assign_current_import_to_trucks: :environment do
    Truck.all.each do |truck|
      import_item = truck.import_items.order(:id).last
      truck.update_attributes(current_import_item_id: import_item.id) if import_item
    end
  end

  desc "updating last loading date for import items"
  task update_last_loading_date: :environment do
    Import.find_each do |import|
      loading_date = import.estimate_arrival + 8.days if import.estimate_arrival.present?
      import.import_items.update_all(last_loading_date: loading_date) if loading_date.present?
    end
  end
end