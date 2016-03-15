class DailyReportWorker 
  include Sidekiq::Worker

  def perform(customer_id, type)
    customer = Customer.find(customer_id)

    p '*********************'
    p "starting #{customer.name}"
    if type == 'export'
      p '*************************************'
      p 'process started' 
      daily_report = Report::Daily.new
      daily_report.create(customer)
      p '*************************************'
      p 'process completed' 
    else
      p '*************************************'
      p 'process started' 
      daily_report = Report::DailyImport.new
      daily_report.create(customer)
      p '*************************************'
      p 'process completed' 
    end
    p '*********************'
    p 'Now Sending Mail'
    UserMailer.mail_report(customer, type).deliver
          
  end
end
