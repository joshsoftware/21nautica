# Petty Cash Mangement Controller
class PettyCashesController < ApplicationController
  before_action :set_date, :set_expense_head, :set_trucks ,only: %i[new create]
  def index
    if params[:date_filter] && params[:date_filter][:date].present?
      start_date, end_date = params[:date_filter][:date].split(' - ')
      start_date = start_date.to_date.strftime('%Y/%m/%d')
      end_date = end_date.to_date.strftime('%Y/%m/%d')
      @petty_cashes = PettyCash.having_records_between(start_date, end_date)
                               .order(date: :desc)
                               .includes(:truck, :expense_head, :created_by)
                               .paginate(page: params[:page], per_page: 20)
    else        
      @petty_cashes = PettyCash.having_records_between(Date.today-7.days, Date.today).order(id: :desc)
                              .includes(:truck, :expense_head, :created_by)
                              .paginate(page: params[:page], per_page: 20)
  
    end
  end

  def new
    @petty_cash = PettyCash.new
  end

  def create
    @petty_cash = current_user.petty_cashes.build(petty_cash_params)
    if @petty_cash.save
      PettyCash.update_transport_cash(current_user,params[:petty_cash][:transaction_amount]) if @petty_cash.expense_head.name.eql?('Trip Allowance')
      flash[:notice] = I18n.t 'petty_cash.saved'
      redirect_to :new_petty_cash
    else
      render 'new'
    end
  end

  private

  def petty_cash_params
    params.require(:petty_cash).permit(
      :date,
      :transaction_amount, :transaction_type,
      :description, :expense_head_id, :truck_id
    )
  end
  

  def set_date
    @date = PettyCash.last.try(:date) || Date.current.beginning_of_year-10.year 
  end

  def set_expense_head
    @expense_heads = ExpenseHead.active.order(:name).map { |expense_head| [expense_head.name, expense_head.id, { 'data-is_related_to_truck' => expense_head.is_related_to_truck }] }
  end

  def set_trucks
    @trucks = Truck.order(:reg_number).pluck(:reg_number, :id).uniq {|truck| truck[0]}
  end
end
