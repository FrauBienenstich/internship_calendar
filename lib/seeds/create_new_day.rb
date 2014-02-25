def create_new_day(date)
  day = Day.create!(:date => date)
  Slot.create!(:name => "9am - 10am", :day_id => day.id)
  Slot.create!(:name => "10am - 12 am", :day_id => day.id)
end