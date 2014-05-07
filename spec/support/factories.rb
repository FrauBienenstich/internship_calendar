FactoryGirl.define do


  factory :person, aliases: [:host, :intern] do
    name "Susanne"
    sequence (:email) { |n| "email#{n}@factory.com"}
  end
  
  factory :internship do
    description "Blabla"
    host
    day { FactoryGirl.create(:day)}
    start_time {day.date + 4.hours}
    end_time {day.date + 5.hours}
  end

  factory :day do
    #date Date.new(1986, 4, 21)
    sequence (:date) { |n| n.days.from_now}
  end
end