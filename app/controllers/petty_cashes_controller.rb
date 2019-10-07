# Petty Cash Mangement Controller
class PettyCashesController < ApplicationController
  def index
    @petty_cashes = PettyCash.order(id: :desc)
                             .includes(:truck, :expense_head, :created_by)
                             .paginate(page: params[:page], per_page: 20)
  end

  def new
    @petty_cash = PettyCash.new
    @expense_heads = ExpenseHead.active.order(:name).map { |expense_head| [expense_head.name, expense_head.id, { 'data-is_related_to_truck' => expense_head.is_related_to_truck }] }
    @trucks = Truck.order(:reg_number).pluck(:reg_number, :id).uniq { |truck| truck[0] }
  end

  def create
    @petty_cash = current_user.petty_cashes.build(petty_cash_params)
    if @petty_cash.save
      check_expense_head
      flash[:notice] = I18n.t 'petty_cash.saved'
      redirect_to :new_petty_cash
    else
      render 'new'
    end
  end

  private

  def petty_cash_params
    params.require(:petty_cash).permit(
      :transaction_amount, :transaction_type,
      :description, :expense_head_id, :truck_id
    )
  end

  def check_expense_head
    if @petty_cash.expense_head.name.eql?('Trip Allowence')
      last_balance = TransportMangerCash.where.not(transaction_date:nil)
                                        .last.try(:available_balance).to_f
      balance = last_balance + params[:petty_cash][:transaction_amount].to_f
      transport = current_user
                  .transport_manger_cashes
                  .new(transaction_date: Date.today,
                       transaction_type: 'Deposit',
                       transaction_amount: params[:petty_cash][:transaction_amount],
                       available_balance: balance)
      transport.save
    end
  end
end
