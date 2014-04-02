def create_new_day(date)
  day = Day.create!(:date => date)
  dt = date.to_datetime
end