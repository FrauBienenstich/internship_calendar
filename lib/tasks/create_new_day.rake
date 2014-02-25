desc "Creates a new day"
task :create_new_day => :environment do
  today = Date.new(2014,4,21)
  day = Day.create!(:date => today)
  Slot.create!(:name => "9am - 10am", :day_id => day)
  Slot.create!(:name => "10am - 12 am", :day_id => day)
  Rails.logger.info "#{Time.zone.now.to_s} -  A new day was created!"  
end