# Testing editing an trip feature

require 'spec_helper'

feature 'Editing Trips feature' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user)}
  
  before do
    login_as(user, :scope => :user)
    visit trips_path
		click_link_or_button trip.title
		click_link 'Settings'
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

	scenario 'editing an trip' do
		fill_in 'Trip Title:', with: 'Revised Trip Title'
		fill_in 'Start', with: (trip.start_date + 2.days).strftime("%m/%d/%y") 
		fill_in 'End', with: (trip.end_date + 2.days).strftime("%m/%d/%y") 
		select 'public', from: 'Privacy'

		click_button 'Update'

		expect(page).to have_content('Your trip has been updated')

		visit trips_path
		click_link_or_button 'Revised Trip Title'

		expect(page).to have_content('Revised Trip Title')
	end

  scenario "cancel button takes you back to the trips page" do
    click_button 'Cancel'

    expect(page).to have_content('Your changes have been cancelled.')
    current_url.should eq trip_url(trip)
  end
end
