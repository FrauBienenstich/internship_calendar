def create_new_day
  @today = Date.new(2014,04,21)
  day = Day.create!(:date => @today)
  Slot.create!(:name => "9am - 10am", :day_id => day.id)
  Slot.create!(:name => "10am - 12 am", :day_id => day.id)
end