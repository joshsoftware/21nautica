class UserMailer < ActionMailer::Base
  default from: ENV['SENDGRID_USERNAME']
  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    attachments['attachment.pdf'] = File.read('file.pdf')
    p @user.emails
    mail(to: @user.emails, subject: 'Welcome to My Awesome Site')
	end
end
