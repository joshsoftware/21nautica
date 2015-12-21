class CustomersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :only => [:analysis_report, :margin_analysis_report]

  def index
    @customers = Customer.all.order(name: :asc)
  end

  def new
    @customer = Customer.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    customer = Customer.new(customer_params)
    if request.xhr?
      customer.save ? @customers = Customer.order(:name).to_a : @errors = customer.errors.messages.values.flatten
      render 'new'
    else
      if customer.save
        flash[:notice] = 'Customer created successfully'
        redirect_to customers_path
      else
        render 'new'
      end
    end
  end

  def analysis_report
    @customers = Customer.all.order(name: :asc).collect{ |c| [c.name, c.id] }.unshift(['All Customers', 'all'])
    authorize! :analysis_report, Customer 
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to customers_path
    else
      render 'edit'
    end
  end

  def margin_analysis_report
    all_customers = params[:customer_id].eql?('all') 
    customers =  all_customers ? 'all' : params[:customer_id]
    month = Date::MONTHNAMES[Date.strptime(params[:month], '%m-%Y').month]
    selected_month = Date.strptime(params[:month], '%m-%Y')
    
    #set the Worksheet name
    worksheet_name = "margin report - #{month} "
    Report::CustomerAnalysis.new.calculate_margin(customers, month, selected_month, worksheet_name)

    file_path = "#{Rails.root}/tmp/#{worksheet_name}#{selected_month.strftime("%Y")}.xlsx"
    File.open(file_path, 'r') do |f|
      send_data f.read, filename: "#{worksheet_name}#{selected_month.strftime("%Y")}.xlsx", type: 'application/xlsx' 
    end

    File.delete(file_path)

    #authorize! :margin_analysis_report, Customer 
  end

  private
  def customer_params
    params.require(:customer).permit(:name, :emails)
  end

end
