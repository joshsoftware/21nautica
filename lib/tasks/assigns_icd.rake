namespace :assign_icd do

  desc "Assings ICD to Import Item"
  task assign_icd_to_import_item: :environment do 
    import_expense = ImportExpense.where(category: 'ICD').where.not(name: "")

    import_expense.each do |import_expense|
      import_item = import_expense.import_item
      vendor = Vendor.where(name: import_expense.name, vendor_type: 'icd').first
      import_item.update_attribute(:icd_id, vendor.id)
    end
  end
end
