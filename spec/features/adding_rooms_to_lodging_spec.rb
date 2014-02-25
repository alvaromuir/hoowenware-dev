# Testing Adding a Room to a Lodging feature

require "spec_helper"

feature "Adding a room to a lodging feature" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:rsvp) { FactoryGirl.create(:rsvp, user: user, response: 'yes') }
  let!(:lodging) { FactoryGirl.create(:lodging, trip: trip, user: user) }

  before do
    login_as(user, :scope => :user)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'Adding a room' do
    visit trip_path(trip)
    
    within '.going' do
      click_link_or_button 'View lodging itenerary'
    end

    click_link_or_button 'Add a room to this lodging'

    fill_in 'Name:', with: 'An Example Room Name'
    fill_in 'Price:', with: 199.99
    fill_in 'Minimum Stay:', with: 2
    fill_in 'Room Type:', with: 'Double Queen'
    fill_in 'Amenities:', with: 'Some wallpaper, coffemaker and windbreakers'
    fill_in 'Deadline:', with: (Time.now + 30.days).strftime("%m/%d/%y") 
    fill_in 'Deposit:', with: 45.00
    check 'Credit Card Required?'
    fill_in 'Minimum Age:', with: 21
    select 'female', from: 'Room Gender:'
    fill_in 'Notes:', with: 'Some notes about the room will go here, I guess?'
    fill_in 'Room Sleeps:', with: 4

    click_link_or_button 'Add Room'

    expect(page).to have_content('Your room has been added to this lodging.')
  end
end
