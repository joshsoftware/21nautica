class UserMailer < ActionMailer::Base
  default from: "kaushik@21nautica.com"
  def mail_report(customer)
    @customer = customer
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")

    daily_report =Report::Daily.new
    daily_report.create(@customer)

    attachments["#{customer.name.tr(" ", "_")}_#{time}.xlsx"] = File.read("#{Rails.root}/tmp/#{customer.name.tr(" ", "_")}_#{time}.xlsx")
    mail(to: @customer.emails, subject: "Customer Update #{customer.name}")
  end
  def welcome_message_import(import)
    @import = import
    customer = Customer.find(@import.customer_id)
    mail(to: customer.emails,subject: "Welcome")
  end
end
