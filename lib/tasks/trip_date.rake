namespace :trip_date do
  desc "Setting trip date for old records as loaded out port date"
  task set: :environment do
     StatusDate.where.not(loaded_out_of_port: nil).each do |status_date|
        p "Setting status for status_date - #{status_date.id}"
       status_date.update_column(:trip_date, status_date.loaded_out_of_port)
     end
  end
end
