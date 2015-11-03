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
    @customer = Customer.all.order(name: :asc)
  end

  def margin_analysis_report
    customer_id = params[:customer]
    month = Date::MONTHNAMES[Date.strptime(params[:month], '%m-%Y').month]
    customer = Customer.find customer_id
    selected_month = Date.strptime(params[:month], '%m-%Y')
    invoices = Invoice.where(customer_id: customer_id, date: selected_month.beginning_of_day..selected_month.end_of_month)

    Report::CustomerAnalysis.new.calculate_margin(customer, invoices, month)
    file_path = "#{Rails.root}/tmp/margin_analysis_#{customer.name.tr(' ', '_')}.xlsx"
    File.open(file_path, 'r') do |f|
      send_data f.read, filename: "margin_analysis_#{customer.name.tr(' ', '_')}.xlsx", type: "application/xlsx"#, disposition: 'download'
    end
    File.delete(file_path)

  end

  private
  def customer_params
    params.require(:customer).permit(:name, :emails)
  end

end
