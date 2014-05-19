# require_relative '../seeds/create_new_day.rb'

# desc "Creates a new day"
# task :create_new_day, :date do |task, args|
#   #date = args[:date]

#   create_new_day(args[:date])

#   Rails.logger.info "#{Time.zone.now.to_s} -  A new day was created!"  
# end

require_relative '../seeds/create_new_day.rb'

desc "Creates a new day"
task :create_new_day => :environment do
  # Day.delete_all
  # Slot.delete_all
  create_new_day("2018-05-19")#(Date.today)
  #TODO write a rake task that takes the desired date as an argument

  Rails.logger.info "#{Time.zone.now.to_s} -  A new day was created!"  
end