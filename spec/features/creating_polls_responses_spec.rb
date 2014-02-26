# Testing Responding to a Poll feature

require "spec_helper"

feature "Responding to a Poll" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user)}
  let!(:date_poll) { FactoryGirl.create(:date_poll, trip_id: trip.id) }
  let!(:location_poll) { FactoryGirl.create(:location_poll, trip_id: trip.id) }
  let!(:generic_poll) { FactoryGirl.create(:generic_poll, trip_id: trip.id, user: user) }
  
  before do
    login_as(user, :scope => :user)
    visit trip_url(trip)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'responding to a location poll' do
    click_link_or_button 'vote for this location'

    click_link_or_button 'Yes'

    expect(page).to have_content('Your response has been recorded.')
  end

  scenario 'responding to a dates poll' do
    click_link_or_button 'vote for these dates'

    click_link_or_button 'No'

    expect(page).to have_content('Your response has been recorded.')
  end
end
