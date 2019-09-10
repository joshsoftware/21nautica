class ExpenseHeadController < ApplicationController
  before_action :find_expense_head_id, only: [:update, :destroy] 
  def new
    @expense_head = ExpenseHead.new
  end

  def show
    @expense_heads = ExpenseHead.all()  
  end
  def index
    @expense_heads = ExpenseHead.all
  end

  def edit
    @expense_head = ExpenseHead.find_by(id: params[:id])
  end

  def create
    @expense_head = ExpenseHead.new(expense_head_params)
    if @expense_head.save
      flash[:notice] = "Expense Head saved sucessfully"
      redirect_to expense_head_index_path
    else
      render 'new'
    end    
  end

  def update
    if @expense_head.update(expense_head_params)
      flash[:notice] = "Expense head updated sucessfully"
      redirect_to :expense_head_index
    else
      render 'edit'
    end
  end
 
  def destroy
    @expense_head.update_attributes(is_active: false)
    redirect_to :expense_head_index
  end
  private
    def find_expense_head_id
    @expense_head = ExpenseHead.find_by(id: params[:id])
    end
    
    def expense_head_params
      params.require(:expense_head).permit(:name, :is_related_to_truck)
    end


end
