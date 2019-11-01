# Petty Cash Mangement Controller
class PettyCashesController < ApplicationController
  before_action :set_date, :set_expense_head, :set_trucks ,only: %i[new create]
  def index
    if params[:date_filter] && params[:date_filter][:date].present?
      start_date, end_date = params[:date_filter][:date].split(' - ')
      start_date = start_date.to_date
      end_date = end_date.to_date
      @petty_cashes = request.original_url.split(/[\/,?]/).include?('petty_cashes') ? set_records_with_date('Cash',start_date,end_date) : set_records_with_date('Bank',start_date, end_date)
    else
      @petty_cashes = request.original_url.split(/[\/,?]/).include?('petty_cashes') ? set_records_with_default_date('Cash') : set_records_with_default_date('Bank')
    end
  end

  def new
    @petty_cash = PettyCash.new
  end

  def create
    @petty_cash = current_user.petty_cashes.build(petty_cash_params)
    if @petty_cash.save
      if params[:petty_cash][:account_type].eql?('Cash')
        flash[:notice] = I18n.t 'petty_cash.saved'
        redirect_to :new_petty_cash
      else
        flash[:notice] = 'Mpesa Saved'
        redirect_to :new_mpesaes
      end 
    else
      render 'new'
    end
  end

  private

  def petty_cash_params
    params.require(:petty_cash).permit(
      :date,
      :transaction_amount, :transaction_type,
      :description, :expense_head_id, :truck_id,
      :account_type
    )
  end
  

  def set_date
    key = request.original_url.split(/[\/,?]/).include?('petty_cashes') ? 'Cash' : 'Bank'
    @date = PettyCash.of_account_type(key).last.try(:date) || Date.current.beginning_of_year-10.year
  end

  def set_expense_head
    @expense_heads = ExpenseHead.active.order(:name).map { |expense_head| [expense_head.name, expense_head.id, { 'data-is_related_to_truck' => expense_head.is_related_to_truck }] }
  end

  def set_trucks
    @trucks = Truck.order(:reg_number).pluck(:reg_number, :id).uniq {|truck| truck[0]}
  end

  def set_records_with_date(key,start_date, end_date)
    PettyCash.of_account_type(key).having_records_between(start_date, end_date)
                      .order(date: :desc)
                      .includes(:truck, :expense_head, :created_by)
                      .paginate(page: params[:page], per_page: 1000)
  end

  def set_records_with_default_date(key)
    PettyCash.of_account_type(key).having_records_between(Date.today-7.days, Date.today).order(date: :desc)
    .includes(:truck, :expense_head, :created_by)
    .paginate(page: params[:page], per_page: 1000)    
  end

end

