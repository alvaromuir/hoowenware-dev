# Testing cancelling trips feature

require 'spec_helper'

feature 'Canceling Trips feature' do
	let!(:user) { FactoryGirl.create(:user) }
	let!(:user2) { FactoryGirl.create(:user) }
	let!(:trip) { FactoryGirl.create(:trip, user: user) }

	before do
	end

  after do
  end

	scenario 'cancelling an trip is not allowed by non-trip owner' do
		sign_in_as!(user2)
		visit "#{trip_url(trip)}/cancel"

		expect(page).to have_content("You must be an administrator of this trip to do that.")

		visit '/'
		expect(page).to have_content(trip.title)
	end

	scenario 'cancelling an trip is allowed by trip owner' do
		sign_in_as!(user)
		visit user_url(user)
    click_link trip.title
    click_link 'Cancel this trip'

		expect(page).to have_content("Your trip has been cancelled.")

    within '#cancelled_trips' do
      page.should have_link trip.title
    end

		visit '/'

		expect(page).to have_no_content(trip.title)
	end


end
