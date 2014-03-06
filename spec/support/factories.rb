FactoryGirl.define do


  factory :person, aliases: [:host, :intern] do
    name "Susanne"
    sequence (:email) { |n| "email#{n}@factory.com"}
  end

  factory :slot do
    name '1 - 2 pm'
  end
  
  factory :internship do
    description "Blabla"
    host
    slot { FactoryGirl.create(:slot)}
  end
end