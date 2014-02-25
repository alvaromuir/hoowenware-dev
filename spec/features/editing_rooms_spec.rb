# Testing Editing a Room feature

require "spec_helper"

feature "Editing a room" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:rsvp) { FactoryGirl.create(:rsvp, user: user, response: 'yes') }
  let!(:lodging) { FactoryGirl.create(:lodging, trip: trip, user: user) }
  let!(:room) { FactoryGirl.create(:room, lodging: lodging, user: user) }

  before do
  end

  after do
    Warden.test_reset!
  end

  scenario 'editing a room' do
    login_as(user, :scope => :user)
    visit trip_lodging_room_path(:trip_id => trip.id,
                                      :lodging_id => lodging.id,
                                      :id => room.id)

    click_link_or_button 'Update this room'


    fill_in 'Price:', with: 299.99
    fill_in 'Minimum Stay:', with: 3
    fill_in 'Room Type:', with: 'Quadruple Queen'
    fill_in 'Deposit:', with: 85.00
    fill_in 'Notes:', with: 'Updated, for your pleasure'
    fill_in 'Room Sleeps:', with: 6

    click_link_or_button 'Update Room'

    expect(page).to have_content('Your room has been updated.')
    logout(:user)
  end

  scenario 'non-room owners can not edit a room' do
    login_as(user2, :scope => :user)
    visit trip_lodging_room_path(:trip_id => trip.id,
                                      :lodging_id => lodging.id,
                                      :id => room.id)

    expect(page).to_not have_content('Update this room')


    visit edit_trip_lodging_room_path(:trip_id => trip.id,
                                      :lodging_id => lodging.id,
                                      :id => room.id)

    expect(page).to have_content('You cannot make changes to this room.')
    logout(:user2)
  end
end