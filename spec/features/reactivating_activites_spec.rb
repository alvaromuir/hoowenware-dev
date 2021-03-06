# Testing Reactivating Activities feature

require "spec_helper"

feature "Reactivating Activities feature" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:activity) { FactoryGirl.create(:activity, trip: trip, user: user, is_active: false ) }

  before do
  end

  after do
    Warden.test_reset!
  end

  scenario 'reactivating an activity from the activity page' do
    login_as(user, :scope => :user)
    visit trip_activity_path(:id => activity.id,
                              :trip_id => trip.id)
    
    click_link_or_button 'Reactivate this activity'

    expect(page).to have_content('Your activity has been updated.')
    logout(:user)
  end

  scenario 'reactivating an activity from the users profile page' do
    login_as(user, :scope => :user)
    visit user_path(user)
    
    within '.activities' do
      click_link_or_button 'Reactivate this activity'
    end

    expect(page).to have_content('Your activity has been updated.')
    logout(:user)
  end

  scenario 'non-activity owners cannot reactivate an activity' do
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