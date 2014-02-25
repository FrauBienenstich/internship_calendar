require_relative '../seeds/create_new_day.rb'

desc "Creates a new day"
task :create_new_day => :environment do
  Day.delete_all
  Slot.delete_all
  create_new_day

  Rails.logger.info "#{Time.zone.now.to_s} -  A new day was created!"  
end