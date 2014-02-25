# Testing Cancelling Activities feature

require "spec_helper"

feature "Cancelling Activities feature" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:rsvp) { FactoryGirl.create(:rsvp, user: user, response: 'yes') }
  let!(:activity) { FactoryGirl.create(:activity, trip: trip, user: user) }

  before do
  end

  after do
    Warden.test_reset!
  end

  scenario 'cancelling an activity from the trips page' do
    login_as(user, :scope => :user)
    visit trip_path(trip)
    
    within '.activities' do
      click_link_or_button activity.name
    end

    click_link_or_button 'Cancel this activity'

    expect(page).to have_content('Your activity has been cancelled.')
    logout(:user)
  end

  scenario 'cancelling an activity from user profile page' do
    login_as(user, :scope => :user)
    visit user_path(user)
    
    within '.activities' do
      click_link_or_button 'Cancel this activity'
    end

    expect(page).to have_content('Your activity has been cancelled.')
    logout(:user)
  end

  scenario 'non-activity owners cannot cancel an activity' do
    login_as(user2, :scope => :user)
    visit trip_path(trip)
    
    within '.activities' do
      click_link_or_button activity.name
    end

    expect(page).to_not have_content('Cancel this activity')

    visit cancel_trip_activity_path(:id => activity.id,
                                    :trip_id => trip.id)
    expect(page).to have_content('You cannot make changes to this activity.')
    logout(:user)
  end
  
end
