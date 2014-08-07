class UserMailer < ActionMailer::Base
  default from: ENV['SENDGRID_USERNAME']
  def mail_report(user)
  	@user = user
    time = DateTime.parse(Time.now.to_s).strftime("%d_%b_%Y")
    daily_report =Report::Daily.new
    daily_report.create(@user)
	attachments["#{user.name.tr(" ", "_")}_#{time}.xlsx"] = File.read("#{Rails.root}/tmp/#{user.name.tr(" ", "_")}_#{time}.xlsx")
    mail(to: @user.emails, subject: 'DAILY REPORT')
  end
end