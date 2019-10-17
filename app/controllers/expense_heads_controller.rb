# Expense Head Class
class ExpenseHeadsController < ApplicationController
  before_action :set_expense_head, only: %i[edit update]
  def index
    @expense_heads = ExpenseHead.order(:name).paginate(page: params[:page], per_page: 20)
  end

  def new
    @expense_head = ExpenseHead.new
  end

  def create
    @expense_head = ExpenseHead.new(expense_head_params)
    if @expense_head.save
      flash[:notice] = I18n.t 'expense_head.saved'
      redirect_to :expense_heads
    else
      render 'new'
    end
  end

  def update
    if @expense_head.update(update_expense_head_params)
      flash[:notice] = I18n.t 'expense_head.update'
      redirect_to :expense_heads
    else
      render 'edit'
    end
  end

  private

  def set_expense_head
    @expense_head = ExpenseHead.find_by(id: params[:id])
  end

  def expense_head_params
    params.require(:expense_head).permit(:name, :is_related_to_truck)
  end

  def update_expense_head_params
    params.require(:expense_head).permit(:name, :is_related_to_truck,
                                         :is_active)
  end
end
