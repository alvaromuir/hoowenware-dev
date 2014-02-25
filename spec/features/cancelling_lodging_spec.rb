# Testing Cancelling Lodging feature

require "spec_helper"

feature "Cancelling Lodging feature" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:rsvp) { FactoryGirl.create(:rsvp, user: user, response: 'yes') }
  let!(:lodging) { FactoryGirl.create(:lodging, trip: trip, user: user) }

  before do
  end

  after do
    Warden.test_reset!
  end

  scenario 'cancelling lodging plans from the trips page' do
    login_as(user, :scope => :user)
    visit trip_path(trip)

    within '.going' do
      click_link_or_button 'View lodging itenerary'
    end

    click_link_or_button 'Cancel this lodging itenerary'

    expect(page).to have_content('Your lodging plans have been cancelled.')
    logout(:user)
  end

  scenario 'cancelling lodging plans from user profile page' do
    login_as(user, :scope => :user)
    visit user_path(user)

    within '.lodging-arrangments' do
      click_link_or_button 'Cancel this itenerary'
    end

    expect(page).to have_content('Your lodging plans have been cancelled.')
    logout(:user)
  end

  scenario 'non-lodging owners cannot cancel an lodging' do
    login_as(user2, :scope => :user)
    visit trip_path(trip)
    
    expect(page).to_not have_content('Cancel this lodging itenerary')

    visit cancel_trip_lodging_path(:id => lodging.id,
                                    :trip_id => trip.id)
    expect(page).to have_content('You cannot make changes to this lodging.')
    logout(:user)
  end
  
end
