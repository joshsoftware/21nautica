class MailInterceptor
  def self.delivering_email(message)
    message.to = ['paritoshbotre@joshsoftware.com']
  end
end
ActionMailer::Base.register_interceptor(MailInterceptor) unless (Rails.env.production? || Rails.env.test?)
