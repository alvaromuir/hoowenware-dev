# Testing Reactivating a Room feature

require "spec_helper"

feature "Reactivating a room" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:rsvp) { FactoryGirl.create(:rsvp, user: user, response: 'yes') }
  let!(:lodging) { FactoryGirl.create(:lodging, trip: trip, user: user) }
  let!(:room) { FactoryGirl.create(:room, lodging: lodging, user: user, is_active: false) }

  before do
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'reactivating a room from rooms page' do
    login_as(user, :scope => :user)
    visit trip_lodging_room_path(:trip_id => trip.id,
                                      :lodging_id => lodging.id,
                                      :id => room.id)

    click_link_or_button 'Reactivate this room'

    expect(page).to have_content('Your room has been updated.')

  end

  scenario 'reactivating a room from lodging landing page' do
    login_as(user, :scope => :user)
    visit trip_lodging_path(:trip_id => trip.id,
                            :id => lodging.id)

    within ".current_user-room" do
      click_link_or_button 'Reactivate this room'
    end

    expect(page).to have_content('Your room has been updated.')

  end

  scenario 'non room owners can not reactivate a room' do
    login_as(user2, :scope => :user)
    visit trip_lodging_room_path(:trip_id => trip.id,
                                      :lodging_id => lodging.id,
                                      :id => room.id)

    expect(page).to_not have_content('Reactivate this room')

    visit cancel_trip_lodging_room_path(:trip_id => trip.id,
                                        :lodging_id => lodging.id,
                                        :id => room.id)

    expect(page).to have_content('You cannot make changes to this room.')
  end
end