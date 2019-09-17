require 'test_helper'

class ExpenseHeadTest < ActiveSupport::TestCase

  test "Should create a new Expense head"  do
    expense_head = ExpenseHead.create(name: "spare", is_related_to_truck: true)
    assert expense_head.name == 'spare'
    assert expense_head.is_related_to_truck == true
    assert expense_head.is_active == true  
  end
  test "should is_related to truck false " do
    expense_head = ExpenseHead.create(name: "spare")
    assert expense_head.name == 'spare'
    assert expense_head.is_related_to_truck ==  false  
  end
  
  test " should update Expense head " do 
    expense_head = ExpenseHead.create(name: "spare")    
    expense_head.update(name: "spare2")  
    assert expense_head.name =="spare2"  
  end 
 
end
