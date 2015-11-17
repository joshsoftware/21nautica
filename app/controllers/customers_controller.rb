class CustomersController < ApplicationController
  def new
    @customer = Customer.new
  end

  def create
    customer = Customer.new(customer_params)
    customer.save ? @customers = Customer.order(:name).to_a : @errors = customer.errors.messages.values.flatten
    render 'new'
  end

  def analysis_report
    @customers = Customer.all.order(name: :asc).collect{ |c| [c.name, c.id] }.unshift(['All Customers', 'all'])
    authorize! :analysis_report, Customer 
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
