# Testing Reactivating Transportations feature

require "spec_helper"

feature "Reactivating Transportations feature" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:rsvp) { FactoryGirl.create(:rsvp, user: user, response: 'yes') }
  let!(:transportation) { FactoryGirl.create(:transportation, user: user, trip: trip, is_active: false) }

  before do
  end

  after do
    Warden.test_reset!
  end

  scenario 'reactivating a travel plan from the trips page' do
    login_as(user, :scope => :user)
    visit trip_path(trip)
    
    within '.current_user-plans' do
      click_link_or_button 'View travel itenerary'
    end

    click_link_or_button 'Reactivate this travel itenerary'

    expect(page).to have_content('Your transportation plans have been updated.')
    logout(:user)
  end

  scenario 'reactivating a travel plan from a users profile page' do
    login_as(user, :scope => :user)
    visit user_path(user)
    
    within '.travel-plans' do
      click_link_or_button 'Reactivate this itenerary'
    end

    expect(page).to have_content('Your transportation plans have been updated.')
    logout(:user)
  end

  scenario 'non-activity owners cannot reactivate a travel plan' do
    login_as(user2, :scope => :user)
    visit trip_path(trip)
    
    expect(page).to_not have_content('View travel itenerary')

    visit cancel_trip_transportation_path(:id => transportation.id,
                                                  :trip_id => trip.id)
    expect(page).to have_content('You cannot make changes to this transportation plan.')
    logout(:user)
  end
end