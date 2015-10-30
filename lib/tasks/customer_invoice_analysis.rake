require 'csv'

namespace :report do
  desc "Customer Analysis Report"

  task analysis_report: :environment do

    #if Date.today == Date.today.end_of_month

      #customers = Customer.all.order(id: :asc)
      #p "Customer Count: --> #{customers.count}"
      customers = Customer.where(id: 20)
      customers.each do |customer|
        UserMailer.send_analysis_report(customer).deliver
      end

    #end

  end

end
