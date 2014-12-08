class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.to = ['anuja.joshi@joshsoftware.com']
  end
end
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
