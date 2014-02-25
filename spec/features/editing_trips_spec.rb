# Testing editing an trip feature

require 'spec_helper'

feature 'Editing Trips feature' do
	let!(:user) { FactoryGirl.create(:user) }
	let!(:trip) { FactoryGirl.create(:trip, user: user) }

	before do
		sign_in_as!(user)
		visit trips_path
		click_link_or_button trip.title
	end
	
	scenario 'editing an trip' do

		click_link 'Settings'

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
end
