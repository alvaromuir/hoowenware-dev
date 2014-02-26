# Testing Generic Poll Creation feature

require "spec_helper"

feature "Generic Poll Creation" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:rsvp) { FactoryGirl.create(:rsvp, trip: trip, user: user, response: 'yes') }
  
  before do
    login_as(user, :scope => :user)
    visit trip_path(trip)

    within '.posts' do
      click_link_or_button 'create a poll'
    end
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'adding a generic poll' do
    fill_in 'Title:', with: "Who's flying in from NYC?"
    fill_in 'Generic Question [Yes or No]:', with: "Are you leaving from the Greater NY Airports?"
    fill_in 'Notes:', with: "Are you leaving from the Greater NY Airports?"
    fill_in 'Expires:', with: (trip.start_date-3.days).strftime("%m/%d/%y")

    click_link_or_button 'Save'

    expect(page).to have_content('Your poll has been created.')
    expect(page).to have_content("Who's flying in from NYC?")
  end

  scenario "cancel button takes you back to trips page" do
    click_button 'Cancel'

    expect(page).to have_content('Your changes have been cancelled.')
    current_url.should eq trip_url(trip)
  end
end
