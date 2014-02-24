# Testing Creating Transportation feature

require "spec_helper"

feature "Creating Transportation feature" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:rsvp) { FactoryGirl.create(:rsvp, trip: trip, user: user, response: 'yes') }

  before do
    login_as(user, :scope => :user)
    visit trip_path(trip)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'creating a transportation record' do
    
    within '.going' do
      click_link_or_button 'Add travel itenerary'
    end

    select 'airline', from: 'Travel Type:'
    fill_in 'Service Number:', with: '34'
    fill_in 'Seat Number:', with: '2C'
    fill_in 'Price:', with: '245'
    check 'Deposit Required?'
    fill_in 'Notes:', with: 'Example travel arrangement notes.'
    fill_in 'Departure City:', with: 'NYC'
    fill_in 'Departure Date:', with: '03/02/14'
    fill_in 'Departure Time:', with: '03/02/14 12:00PM'
    fill_in 'Arrival City:', with: 'Anywhere, USA'
    fill_in 'Arrival Date:', with: '03/02/14'
    fill_in 'Arrival Time:', with: '03/02/14 3:30PM'

    click_link_or_button 'Create'

    expect(page).to have_content('Your travel arrangements have been submitted.')

    within '.going' do
      expect(page).to have_content('View travel itenerary')
    end
  end
end
