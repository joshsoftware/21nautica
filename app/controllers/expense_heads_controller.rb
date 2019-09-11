# Expense Head Class
class ExpenseHeadsController < ApplicationController
  before_action :find_expense_head_id, only: %i[edit update destroy]
  def index
    @expense_heads = ExpenseHead.all
  end

  def new
    @expense_head = ExpenseHead.new
  end

  def edit
    @expense_head = ExpenseHead.find_by(id: params[:id])
  end

  def create
    @expense_head = ExpenseHead.new(expense_head_params)
    if @expense_head.save
      flash[:notice] = 'Expense Head saved sucessfully'
      redirect_to :expense_heads
    else
      render 'new'
    end
  end

  def update
    if @expense_head.update(update_expense_head_params)
      flash[:notice] = 'Expense head updated sucessfully'
      redirect_to :expense_heads
    else
      render 'edit'
    end
  end

  private

  def find_expense_head_id
    @expense_head = ExpenseHead.find_by(id: params[:id])
  end

  def expense_head_params
    params.require(:expense_head).permit(:name, :is_related_to_truck)
  end

  def update_expense_head_params
    params.require(:expense_head).permit(:name, :is_related_to_truck, :is_active)
  end

end
