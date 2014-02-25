# Testing Reactivation of a Trip
# 
require 'spec_helper'

feature 'Reactivating Trips feature' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user, is_active: false) }

  before do
  end

  scenario 'reactivating a trip' do
    sign_in_as!(user)
    visit user_url(user)
    click_link trip.title
    click_link 'Reactivate this trip'

    expect(page).to have_content('Your trip has been reactivated.')
    within '#active_trips' do
      page.should have_link trip.title
    end
  end

  scenario 'reactivating an trip is not allowed by non-trip owner' do
    sign_in_as!(user2)
    visit "#{trip_url(trip)}/reactivate"

    expect(page).to have_content("  You must be an administrator of this trip to do that.")

    visit '/trips'
    expect(page).to_not have_content(trip.title)
  end
end