FactoryGirl.define do


  factory :person, aliases: [:host, :intern] do
    name "Susanne"
    sequence (:email) { |n| "email#{n}@factory.com"}
  end
  
  factory :internship do
    description "Blabla"
    host
    day { FactoryGirl.create(:day)}
    start_time Time.now
    end_time Time.now + 1.hour
  end

  factory :day do
    date "1986-21-04"
  end
end