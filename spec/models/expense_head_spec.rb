require 'rails_helper'

RSpec.describe ExpenseHead, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it "Should create a new Expense head"  do
    expense_head = ExpenseHead.create(name: "spare", is_related_to_truck: true)
    expect(expense_head.name).not_to eq nil
    expect(expense_head.is_related_to_truck).to eq true
    expect(expense_head.is_active).to eq true  
  end

  it "should is_related to truck Nil " do
    expense_head = ExpenseHead.create(name: "spare")
    expect(expense_head.name).not_to eq nil
    expect(expense_head.is_related_to_truck).to eq nil
    expect(expense_head.is_active).to eq true  
  end
  
  it " should update Expense head " do 
    expense_head = ExpenseHead.create(name: "spare")    
    expense_head.update(name: "spare2")
    expect(expense_head.name).not_to eq "spare"  
    expect(expense_head.name).to eq "spare2"  
  end 
end
