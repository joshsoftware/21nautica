namespace "21nautica" do
  desc "Move all bl_number from field to model"
  task :fix_bl_number do
    Import.all.each do |import|
      import.build_bill_of_lading(bl_number: import.attributes["bl_number"])
      import.save
    end
  end
end

