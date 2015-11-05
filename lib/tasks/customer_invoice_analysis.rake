require 'csv'

namespace :report do
  desc "Customer Analysis Report"

  task analysis_report: :environment do
=begin
    #if Date.today == Date.today.end_of_month
      #customers = Customer.all.order(id: :asc)
      customers = Customer.where(id: 20)
      customers.each do |customer|
        UserMailer.send_analysis_report(customer).deliver
      end
    #end
=end
  end

end
