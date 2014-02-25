require 'spec_helper'
require_relative '../../lib/seeds/create_new_day.rb'

feature 'Host offers slot' do

  scenario 'offers slot for the first time' do
    date = Date.new(2014,04,21)
    create_new_day(date)


    visit 'days/current'

    within('td') do
      fill_in "Email", with: "a@b.de"
    end
    # fill_in :placeholder => "Name", with: "Susanne"

    save_and_open_page
    expect(page).to have_content(date)
    expect(page).to have_content("9am - 10am")
    expect(page).to have_content("10am - 12 am")

    expect(page).to have_content("a@b.de")
    # expect(page).to have_content("Susanne")


  end

  scenario 'has already offered slot before' do

  end

end