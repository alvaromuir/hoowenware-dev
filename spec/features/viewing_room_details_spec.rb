# Testing Viewing a Room feature

require "spec_helper"

feature "Viewing a room" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:user3) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:rsvp) { FactoryGirl.create(:rsvp, user: user, response: 'yes') }
  let!(:lodging) { FactoryGirl.create(:lodging, trip: trip, user: user) }
  let!(:room) { FactoryGirl.create(:room, lodging: lodging, user: user2) }

  before do
    login_as(user3, :scope => :user)
  end

  after do
    logout(:user3)
    Warden.test_reset!
  end

  scenario 'Viewing a room' do
    visit trip_path(trip)
    
    within '.available-lodging' do
      click_link_or_button lodging.name
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