# Petty Cash Mangement Controller
class PettyCashesController < ApplicationController
  before_action :set_date, :set_expense_head, :set_trucks ,only: %i[new create tabular_partial]
  include PettyCashesHelper
  def index
    if params[:date_filter] && params[:date_filter][:date].present?
      start_date, end_date = params[:date_filter][:date].split(' - ')
      start_date = start_date.to_date
      end_date = end_date.to_date
    else
      start_date = Date.today-7.days
      end_date = Date.today
    end
    @petty_cashes = set_records_with_date(for_account, start_date, end_date)
  end

  def new
    @petty_cash = PettyCash.new
  end


  def tabular_partial
    @count = params[:count].present? ? params[:count].to_i + 1 : 0
    @key = params[:key]
    respond_to do |format|
      format.js {  }
    end
  end

  def save_data(petty_cash)
    petty_cash[:account_type] = params[:petty_cash][:account_type]
    @petty_cash = current_user.petty_cashes.build(petty_cash)
    @petty_cash.save
  end

  def create
    values = params[:petty_cash].except(:account_type).values
    sorted_array = values.sort_by{|k| k['date']}
    petty_cash_hash = sorted_array.each {|k| k[:account_type]=params[:petty_cash][:account_type]}
    @petty_cash = current_user.petty_cashes.create(petty_cash_hash)
    PettyCash.adjust_balance(params[:petty_cash][:account_type]) 
    if params[:petty_cash][:account_type].eql?('Cash')
      flash[:notice] = I18n.t 'petty_cash.saved'
      redirect_to :petty_cashes
    elsif params[:petty_cash][:account_type].eql?('Bank')
      flash[:notice] = 'Mpesa Saved'
      redirect_to :mpesaes
    else
      flash[:notice] = 'Petyy Cash NBO is saved'
      redirect_to :petty_cash_nbos
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
    @date = PettyCash.of_account_type(for_account).last.try(:date) || Date.current.beginning_of_year-10.year
  end

  def set_expense_head
    @expense_heads = ExpenseHead.active.order(:name).map { |expense_head| [expense_head.name, expense_head.id, { 'data-is_related_to_truck' => expense_head.is_related_to_truck }] }
  end

  def set_trucks
    @trucks = Truck.order(:reg_number).pluck(:reg_number, :id).uniq {|truck| truck[0]}
  end

  def set_records_with_date(key,start_date, end_date)
    PettyCash.of_account_type(key).having_records_between(start_date, end_date)
                      .order(:date, :id)
                      .includes(:truck, :expense_head, :created_by)
                      .paginate(page: params[:page], per_page: 1000)
  end

  def set_records_with_default_date(key)
    PettyCash.of_account_type(key).having_records_between(Date.today-7.days, Date.today).order(:id,date: :desc)
    .includes(:truck, :expense_head, :created_by)
    .paginate(page: params[:page], per_page: 1000)    
  end
end
