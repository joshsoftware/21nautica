require 'test_helper'

class ImportExpensesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
  	@user = FactoryGirl.create :user
    sign_in @user
  	@import_item2 = FactoryGirl.create :import_item2
    @import_item3 = FactoryGirl.create :import_item3
    @import = FactoryGirl.create :import
    @import_item2.import = @import
    @import_item3.import = @import
    @import_item3.save!
    @import_item2.save!
  end

  test "should get index" do
  	get :index, {"id" => ""}
  	assert_not_nil assigns(:import_items)
  	assert_response :success
  end

  test "should get edit for if single entry is found" do
    get :index, {"id" => "c2"}
    assert_not_nil assigns(:import_items)
    assert_redirected_to edit_import_item_import_expense_path(@import_item2)
  end

  test "should redirect to root if no entry found" do
    get :index, {"id" => "c34"}
    assert_redirected_to root_path
  end

  test "should get edit" do
  	get :edit, {"import_item_id" => @import_item2.id}
    assert_response :success
  end

  test "should update import_item's import expesnse" do
  	expenses = @import_item2.import_expenses.pluck(:id)
    patch :update, "import_item"=>{"import_expenses_attributes"=>{"0"=>{"category"=>"Haulage",
     "amount"=>"600", "currency"=>"USD", "invoice_number"=>"v1", "invoice_date"=>"", "id"=> expenses[0]},
     "1"=>{"category"=>"Empty", "amount"=>"500", "name"=>"Blue Jay", "currency"=>"USD",
     "invoice_number"=>"v1", "invoice_date"=>"", "id"=>expenses[1]}, 
     "2"=>{"category"=>"ICD", "amount"=>"600", "name"=>"Multiple", "currency"=>"USD", 
     "invoice_number"=>"", "invoice_date"=>"", "delivery_date"=>"", "id"=>expenses[2]}, 
     "3"=>{"category"=>"Final Clearing", "amount"=>"600", "name"=>"Agility", "currency"=>"USD", 
     "invoice_number"=>"", "invoice_date"=>"", "delivery_date"=>"", "id"=>expenses[3]}, 
     "4"=>{"category"=>"Demurrage", "amount"=>"500", "currency"=>"USD", "invoice_number"=>"", 
     "invoice_date"=>"", "delivery_date"=>"", "id"=>expenses[4]}}}, 
     "import_item_id"=> @import_item2.id
    assert_equal "600", @import_item2.import_expenses.where(category: "Haulage").first.amount
    assert_redirected_to root_path
  end

end
