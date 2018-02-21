namespace "21nautica" do

  desc "Update closed date for delivered containers for import items"
  task update_close_date: :environment do 
    ImportItem.where(status: 'delivered').each do |import_item|
      import_item.update_attribute(:close_date, import_item.delivery_date) unless import_item.delivery_date.nil?
    end
  end
end
