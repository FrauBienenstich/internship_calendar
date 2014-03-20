# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Day.delete_all
days = Day.create([{date: "2014-03-20"}, {date: "2014-04-21"}])

Slot.delete_all
slots = Slot.create([{start_time: "14:00:00", end_time: "15:00:00", day_id: days[0].id}, {start_time: "10:00:00", end_time: "11:00:00", day_id: days[1].id}])




