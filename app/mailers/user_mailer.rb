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
    mail(from:"anuragpratap92apsc@gmail.com",to: "anuragpratap_apsc@yahoo.in",subject: "Welcome")
  end
end
