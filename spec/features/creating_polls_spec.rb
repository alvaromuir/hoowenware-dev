# Testing Creating Date Polls feature

require 'spec_helper'

feature 'Creating a Date Poll for a Trip' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user)}
  
  before do
    login_as(user, :scope => :user)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'creating a date poll' do
    visit trip_url(trip)
    click_link 'Settings'

    within '.new-trip-dates' do
      click_link 'polls'
    end

    fill_in 'Title:', with: "#{(trip.start_date+30.days).strftime("%B")} Travel Poll"
    fill_in 'Start:', with: (trip.start_date+30.days).strftime("%m/%d/%y")
    fill_in 'End:', with: (trip.end_date+30.days).strftime("%m/%d/%y")
    fill_in 'Notes:', with: 'Mid May?'
    fill_in 'Expires:', with: (trip.end_date-10.days).strftime("%m/%d/%y")

    click_link_or_button 'Save'

    expect(page).to have_content("#{(trip.start_date+30.days).strftime("%B")} Travel Poll")
    expect(page).to have_content (trip.end_date-10.days).strftime("%m/%d/%y")
  end

  scenario 'creating a location poll' do
    visit trip_url(trip)
    click_link 'Settings'

    within '.new-trip-location' do
      click_link 'polls'
    end
    
    fill_in 'Title:', with: 'Alternate Location Poll'
    fill_in 'Location',  with:'Somewhere, anywhere else'
    fill_in 'Notes:', with: 'Where else can we go?'
    fill_in 'Expires:', with: (trip.end_date-5.days).strftime("%m/%d/%y")

    click_link_or_button 'Save'

    expect(page).to have_content('Alternate Location Poll')
    expect(page).to have_content (trip.end_date-5.days).strftime("%m/%d/%y")
  end
end
