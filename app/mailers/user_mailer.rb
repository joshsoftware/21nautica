class UserMailer < ActionMailer::Base
  default from: ENV['SENDGRID_USERNAME']
  def mail_report(customer)
  	@customer = customer
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
    daily_report =Report::Daily.new
    daily_report.create(@customer)
	attachments["#{customer.name.tr(" ", "_")}_#{time}.xlsx"] = File.read("#{Rails.root}/tmp/#{customer.name.tr(" ", "_")}_#{time}.xlsx")
    mail(to: @customer.emails, subject: 'DAILY REPORT')
  end
end