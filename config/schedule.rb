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

set :output, {:standard => 'log/cron.log', :error => 'log/cron_error.log' }


every '1 5 * * *' do
	runner "Day.new_day"
end

every '50 12,18,23 * * *' do 
	runner "Day.runkeeper"
end

every '20 3,6,9,12,15,18,21 * * *' do
	runner "Day.jawbone"
end

every '30 * * * *' do 
	runner "Day.reporter"
end

every '10 * * * *' do 
	runner "Day.moves"
end