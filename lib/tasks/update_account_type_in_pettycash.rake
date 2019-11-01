namespace "account_type" do
  desc "Update account type to cash in petty cash"
  task update_account_type_to_cash: :environment do 
    PettyCash.all.each do |petty_cash|
      petty_cash.update_attribute(:account_type, "Cash")
    end
  end
end