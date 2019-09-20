# Petty Cash Mangement Controller
class PettyCashesController < ApplicationController
  before_action :update_available_balance, only: %i[create]
  def index
    @petty_cash = PettyCash.all
  end

  def new
    @petty_cash = PettyCash.new
    @expense_heads = ExpenseHead.active.map { |expense_head| [expense_head.name, expense_head.id, { 'data-is_related_to_truck' => expense_head.is_related_to_truck }] }
    @trucks = Truck.all.map { |truck| [truck.reg_number, truck.id] }
  end

  def create
    @petty_cash = current_user.petty_cashes.new(petty_cash_params)
    if @petty_cash.save
      flash[:notice] = 'Petty Cash saved '
      redirect_to :petty_cashes
    else
      render 'new'
    end
  end

  private

  def petty_cash_params
    params.require(:petty_cash).permit(
      :transaction_amount, :transaction_type,
      :description, :expense_head_id, :truck_id, :available_balance
    )
  end

  def update_available_balance
    available_balance =
      PettyCash.count.zero? ? 0.00 : PettyCash.last.available_balance
    transaction_amount = params[:petty_cash][:transaction_amount].to_f
    if params[:petty_cash][:transaction_type].eql?('Deposit')
      params[:petty_cash][:available_balance] = available_balance + transaction_amount
    else
      params[:petty_cash][:available_balance] = available_balance - transaction_amount
    end
  end
end
