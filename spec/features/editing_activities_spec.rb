# Testing Editing Activities feature

require "spec_helper"

feature "Editing Activities feature" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:activity) { FactoryGirl.create(:activity, trip: trip, user: user) }

  before do
  end

  after do
    Warden.test_reset!
  end

  scenario 'editing an Activity' do
    login_as(user, :scope => :user)
    visit trip_path(trip)
    
    within '.activities' do
      click_link_or_button activity.name
    end

    click_link_or_button 'Update this activity'

    fill_in 'Price:', with: 7.99
    fill_in 'Date:', with: (activity.date + 2.days).strftime("%m/%d/%y")
    fill_in 'Start Time:', with: ((activity.date + 2.days).change({:hour=> 19, min: 30})).strftime("%I:%m%p")
    fill_in 'End Time:', with: ((activity.date + 2.days).change({:hour=> 22, min: 30})).strftime("%I:%m%p")
    fill_in 'Notes:', with: 'Updated Activity'

    click_link_or_button 'Update'

    expect(page).to have_content('Your activity details have been updated.')

    within '.activities' do
      click_link_or_button activity.name
    end

    expect(page).to have_content('7.99')
    expect(page).to have_content (activity.date + 2.days).strftime("%m/%d/%y")
    expect(page).to have_content('Updated Activity')

    logout(:user)
  end

  scenario 'non activity owners can not edit an acitivity' do
    login_as(user2, :scope => :user)
    visit trip_path(trip)
    
    within '.activities' do
      click_link_or_button activity.name
    end

    expect(page).to_not have_content('Update this activity')

    visit edit_trip_activity_path(:trip_id => trip.id, :id => activity.id)

    expect(page).to_not have_content('You cannot edit this page.')

    logout(:user2 )
  end
end
