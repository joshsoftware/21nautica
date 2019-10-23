namespace :update_entry_type do
  desc "Updating entry type for import according to entry number"
  task update: :environment do
    Import.all.each do |import|
      if import.entry_number && import.entry_number.downcase.start_with?("c")
        import.update_column(:entry_type, 1)
      elsif import.entry_number
        import.update_column(:entry_type, 0)
      end
    end
  end
end
