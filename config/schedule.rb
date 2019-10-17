# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 1.day, at: '2:00 pm' do
  command 'cd /www/erp-21nautica/current && RAILS_ENV=production bundle exec rake report:export_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every 1.day, at: '2:15 pm' do
  command 'cd /www/erp-21nautica/current && RAILS_ENV=production bundle exec rake report:import_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every 1.day, at: '12:00 pm' do
  command 'cd /www/ug-21nautica/current && RAILS_ENV=production bundle exec rake report:export_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every 1.day, at: '12:15 pm' do
  command 'cd /www/ug-21nautica/current && RAILS_ENV=production bundle exec rake report:import_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every 1.day, at: '4:00 pm' do
  command 'cd /www/int-21nautica/current && RAILS_ENV=production bundle exec rake report:export_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every 1.day, at: '4:15 pm' do
  command 'cd /www/int-21nautica/current && RAILS_ENV=production bundle exec rake report:import_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every 1.day, at: '10:00 am' do
  command 'cd /www/rfs-21nautica/current && RAILS_ENV=production bundle exec rake report:export_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every 1.day, at: '10:15 am' do
  command 'cd /www/rfs-21nautica/current && RAILS_ENV=production bundle exec rake report:import_report --silent >> log/cron.log 2>> log/cron_error.log'
end

every 1.day, at: '12:05 am' do
  command 'cd /www; sh backup.sh >> backup.log'
end

every 1.day, at: '05:30 am' do
  command 'cd /www/rfs-21nautica/current && RAILS_ENV=production bundle exec rake automated_emails:bl_entry_number_reminder --silent >> log/cron.log 2>> log/cron_error.log'
end

every 1.day, at: '12:30 pm' do
  command 'cd /www/rfs-21nautica/current && RAILS_ENV=production bundle exec rake automated_emails:bl_entry_number_reminder --silent >> log/cron.log 2>> log/cron_error.log'
end