FactoryGirl.define do

  factory :import_expense1, class: "ImportExpense" do
    category "Haulage"
  end

  factory :import_expense2, class: "ImportExpense" do
    category "Empty"
  end
  
  factory :import_expense3, class: "ImportExpense" do
    category "ICD"
  end                   

  factory :import_expense4, class: "ImportExpense" do
    category "Final Clearing"
  end  
  factory :import_expense5, class: "ImportExpense" do
    category "Demurrage"
  end                   


end

