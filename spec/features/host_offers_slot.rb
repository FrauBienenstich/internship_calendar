require 'spec_helper'
require_relative '../../lib/seeds/create_new_day.rb'

feature 'Host offers slot' do

  scenario 'offers slot for the first time' do
    create_new_day
    date = Date.new(2014,04,21)
    create_new_day(date)


    visit 'days/current'

    save_and_open_page
    expect(page).to have_content(date)
    expect(page).to have_content("9am - 10am")
    expect(page).to have_content("10am - 12 am")

  end

  scenario 'has already offered slot before' do

  end

end