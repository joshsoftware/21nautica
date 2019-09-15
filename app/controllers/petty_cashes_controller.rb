class PettyCashesController < ApplicationController
  before_action :find_petty_cash_id, only: [:edit, :update, :show, :destory]
  before_action :update_available_balance, only: [:edit, :update, :create]
  def index
    @petty_cash = PettyCash.all
  end

  def new
    @petty_cash = PettyCash.new
    @expense_heads = ExpenseHead.active.map{ |expense_head| [expense_head.name, expense_head.id, {'data-is_related_to_truck'=>expense_head.is_related_to_truck}] }
    @trucks = Truck.all.map { |truck| [truck.reg_number, truck.id] }
    @date = Date.current
  end

  def create
    @petty_cash = PettyCash.new(petty_cash_params)
    if @petty_cash.save
      flash[:notice] = 'Petty Cash saved successfulyy'
      redirect_to :petty_cashes
    else
      render 'new'
    end
  end

  private
  def petty_cash_params
    params.require(:petty_cash).permit(:date, :created_by_id, :transaction_amount, :transaction_type, :description, :expense_head_id, :truck_id, :available_balance)
  end

  def update_available_balance
    last_available_balance = PettyCash.count == 0?0:PettyCash.last.available_balance
    if params[:petty_cash][:transaction_type] === 'deposite' 
      params[:petty_cash][:available_balance] = last_available_balance + params[:petty_cash][:transaction_amount].to_f
    else
      params[:petty_cash][:available_balance] = last_available_balance - params[:petty_cash][:transaction_amount].to_f
    end
  end
end