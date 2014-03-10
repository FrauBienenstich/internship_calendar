require 'spec_helper'
require_relative '../../lib/seeds/create_new_day.rb'

feature 'Host offers slot' do

  scenario 'offers slot for the first time', :js => true do
    date = Date.new(2014,04,21)
    create_new_day(date)

    visit '/'
    save_and_open_page
    # puts page.body

    # click_link("Yes, I want to offer a new internship!")


    # fill_in "Email", with: "a@b.de"
    # # fill_in :placeholder => "Name", with: "Susanne"

    # expect(page).to have_content(date)
    # expect(page).to have_content("9am - 10am")
    # expect(page).to have_content("10am - 12 am")

    # expect(page).to have_content("a@b.de")
    # # expect(page).to have_content("Susanne")


  end

end