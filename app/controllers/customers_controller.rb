class CustomersController < ApplicationController

  def new
    @customer = Customer.new
  end

  def create
    customer = Customer.new(customer_params)
    customer.save
    @customers = Customer.all.to_a
    render 'new'
  end

  def daily_report_export
    customers = []
    movements = Movement.where.not(status: "container_handed_over_to_KPA").select(:booking_number).uniq
    movements.each do |movement|
      export = Export.find_by release_order_number: movement.booking_number
      customers.push(export.customer)
    end
    customers = customers.uniq
    customers.each do |customer|
      UserMailer.mail_report_export(customer).deliver
    end
  end

  def daily_report_import
    customers = []
    import_items = ImportItem.where.not(status: "delivered").select(:import_id).uniq
    import_items.each do |item|
      import = Import.find(item.import_id)
      customers.push(import.customer)
    end
    customers = customers.uniq
    customers.each do |customer|
      UserMailer.mail_report_import(customer).deliver
    end
  end

  private
  def customer_params
    params.require(:customer).permit(:name, :emails)
  end

  def daily_report_params
    params.permit(:name)
  end

end
