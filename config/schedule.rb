
every '0 14 * * 1-6' do #every 1.day, at: '2:00 pm' do
  command 'cd /www/erp-21nautica/current && RAILS_ENV=production bundle exec rake report:export_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every '15 14 * * 1-6' do #every 1.day, at: '2:15 pm' do
  command 'cd /www/erp-21nautica/current && RAILS_ENV=production bundle exec rake report:import_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every '0 12 * * 1-6' do #every 1.day, at: '12:00 pm' do
  command 'cd /www/ug-21nautica/current && RAILS_ENV=production bundle exec rake report:export_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every '15 12 * * 1-6' do #every 1.day, at: '12:15 pm' do
  command 'cd /www/ug-21nautica/current && RAILS_ENV=production bundle exec rake report:import_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every '0 16 * * 1-6' do #every 1.day, at: '4:00 pm' do
  command 'cd /www/int-21nautica/current && RAILS_ENV=production bundle exec rake report:export_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every '15 16 * * 1-6' do#every 1.day, at: '4:15 pm' do
  command 'cd /www/int-21nautica/current && RAILS_ENV=production bundle exec rake report:import_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every '0 10 * * 1-6' do #every 1.day, at: '10:00 am' do
  command 'cd /www/rfs-21nautica/current && RAILS_ENV=production bundle exec rake report:export_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every '15 10 * * 1-6' do #every 1.day, at: '10:15 am' do
  command 'cd /www/rfs-21nautica/current && RAILS_ENV=production bundle exec rake report:import_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every 1.day, at: '12:05 am' do
  command 'cd /www; sh backup.sh >> backup.log'
end

#Every day except Sunday at 7:30 and 13:30
every '30 7,13 * * 1-6' do
  command 'cd /www/rfs-21nautica/current && RAILS_ENV=production bundle exec rake automated_emails:bl_entry_number_reminder --silent >> log/cron.log 2>> log/cron_error.log'
end

every '20 10 * * 1-6' do #every 1.day, at: '10:20 am' do
  command 'cd /www/rfs-21nautica/current && RAILS_ENV=production bundle exec rake automated_emails:container_returned_date_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every '20 10 * * 1-6' do #every 1.day, at: '10:20 am' do
  command 'cd /www/rfs-21nautica/current && RAILS_ENV=production bundle exec rake automated_emails:daily_petty_cash_ledger --silent >> log/cron.log 2>> log/cron_error.log'
end