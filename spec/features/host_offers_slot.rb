require 'spec_helper'

feature 'Host offers slot' do

  scenario 'offers slot for the first time' do
    today = Date.today
    day = Day.create!(:date => today)
    Slot.create!(:name => "9am - 10am", :day => day)
    Slot.create!(:name => "10am - 12 am", :day => day)

    visit '/'
    expect(page).to have_content(today)
    expect(page).to have_content("9am - 10am")

  end

  scenario 'has already offered slot before' do

  end

end