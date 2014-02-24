# Testing Viewing Transportations feature

require "spec_helper"

feature "Viewing Transportations feature" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:rsvp) { FactoryGirl.create(:rsvp, trip: trip, user: user, response: 'yes') }
  let!(:transportation) { FactoryGirl.create(:transportation, user: user, trip: trip) }

  before do
    login_as(user, :scope => :user)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'viewing a travel plan from trips page' do
    visit trip_path(trip)

    within '.current_user-plans' do
      click_link_or_button 'View travel itenerary'
    end

    expect(page).to have_content(transportation.transportation_type)
    expect(page).to have_content(transportation.departure_city)
    expect(page).to have_content(transportation.departure_date.to_date.strftime("%m/%d/%y"))
    expect(page).to have_content(transportation.arrival_city)
    expect(page).to have_content(transportation.arrival_date.to_date.strftime("%m/%d/%y"))

  end

  scenario 'viewing a travel plan from users profile page' do
    visit user_path(user)

    within '.travel-plans' do
      click_link_or_button transportation.transportation_type
    end

    expect(page).to have_content(transportation.transportation_type)
    expect(page).to have_content(transportation.departure_city)
    expect(page).to have_content(transportation.departure_date.to_date.strftime("%m/%d/%y"))
    expect(page).to have_content(transportation.arrival_city)
    expect(page).to have_content(transportation.arrival_date.to_date.strftime("%m/%d/%y"))

  end

end