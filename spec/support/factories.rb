FactoryGirl.define do

  factory :person do
    name "Susanne"
    email "susanne@dewein.de"
  end

  factory :slot do

    name '1 - 2 pm'
    #day_id '1'
  end
  
  factory :internship do
    description "Blabla"
    host { FactoryGirl.create(:person) }
    slot { FactoryGirl.create(:slot)}
  end
end