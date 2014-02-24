# Testing Deleting Poll Feature

require "spec_helper"

feature "Deleting Polls" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user)}
  let!(:date_poll) { FactoryGirl.create(:date_poll, trip_id: trip.id) }
  
  before do
    login_as(user, :scope => :user)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'Deleting a dates poll' do
    visit edit_trip_url(trip)
    click_link_or_button 'Delete this poll'

    expect(page).to have_content('Your poll has been deleted.')
  end
  
end