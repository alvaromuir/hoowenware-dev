# Testing deleting trips feature

require 'spec_helper'

feature 'Deleting Trips feature' do
	let!(:user) { FactoryGirl.create(:user, is_admin: true) }
	let!(:trip1) { FactoryGirl.create(:trip, user: user) }
	let!(:trip2) { FactoryGirl.create(:trip, user: user) }


	scenario 'non-admins cannot delete an trip' do

		visit '/'
		click_link trip2.title
		expect(page).to_not have_content('Delete This trip')
	end

	scenario 'admis can delete a trip' do
		# for some reason this needs more than default factory
		sign_in_as!(FactoryGirl.create(:admin_user, email: 'admin@dev.hoowenware.com'))

		visit '/'
		click_link trip1.title
		click_link 'Delete this trip'

		expect(page).to have_content("This trip has been deleted.")

		visit '/'

		expect(page).to have_no_content(trip1.title)
	end
end