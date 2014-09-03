class UserMailer < ActionMailer::Base
  default from: "kaushik@21nautica.com"

  def mail_report_export(customer)
    @customer = customer
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
    daily_report =Report::Daily.new
    daily_report.create(@customer)
    attachments["Export_#{customer.name.tr(" ", "_")}_#{time}.xlsx"] = File.read("#{Rails.root}/tmp/#{customer.name.tr(" ", "_")}_#{time}.xlsx")
    mail(to: @customer.emails, subject: "Customer Update #{customer.name}")
  end

  def welcome_message_import(import)
    @import = import
    customer = Customer.find(@import.customer_id)
    mail(to: customer.emails,subject: "Welcome")
  end

  def mail_report_import(customer)
    @customer = customer
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
    daily_report =Report::DailyImport.new
    daily_report.create(@customer)
    attachments["Import_#{customer.name.tr(" ", "_")}_#{time}.xlsx"] = File.read("#{Rails.root}/tmp/Imports_#{customer.name.tr(" ", "_")}_#{time}.xlsx")
    mail(to: @customer.emails, subject: "Customer Update #{customer.name}")
  end
end