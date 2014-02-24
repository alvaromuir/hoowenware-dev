# Testing Editing Activities feature

require "spec_helper"

feature "Editing Activities feature" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:activity) { FactoryGirl.create(:activity, trip: trip, user: user) }

  before do
    login_as(user, :scope => :user)
    visit trip_path(trip)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'editing an Activity' do
    
    within '.activities' do
      click_link_or_button activity.name
    end

    click_link_or_button 'Update this activity'

    fill_in 'Price:', with: '7.99'
    fill_in 'Date:', with: '03/06/14'
    fill_in 'Start Time:', with: '8:00pm'
    fill_in 'End Time:', with: '11:00pm'
    fill_in 'Notes:', with: 'Updated Activity'

    click_link_or_button 'Update'

    expect(page).to have_content('Your activity details have been updated.')
  end
end
