def create_new_day(date)
  day = Day.create!(:date => date)
  dt = date.to_datetime
  Slot.create!(:start_time => (dt + 9.hours), :end_time => (dt + 10.hours), :day_id => day.id)
  Slot.create!(:start_time => (dt + 11.hours), :end_time => (dt + 12.hours), :day_id => day.id)
end