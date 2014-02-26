# Testing Editing Poll Feature

require "spec_helper"

feature "Editing Polls" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user)}
  let!(:date_poll) { FactoryGirl.create(:date_poll, trip_id: trip.id) }
  let!(:location_poll) { FactoryGirl.create(:location_poll, trip_id: trip.id) }
  let!(:generic_poll) { FactoryGirl.create(:generic_poll, trip_id: trip.id, user: user) }
  
  before do
    login_as(user, :scope => :user)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'editing a dates poll' do
    visit edit_trip_url(trip)
    click_link date_poll.title
    
    expect(page).to have_content('Edit your date poll')
    expect(page).to have_content(date_poll.title)

    fill_in 'Notes:', with: 'A new note'
    fill_in 'Expires:', with: ''
    click_link_or_button 'Update'

    expect(page).to have_content('Your poll has been updated.')
  end

  scenario 'editing a location poll' do
    visit edit_trip_path(trip)
    click_link location_poll.title
    
    expect(page).to have_content('Edit your location poll')
    expect(page).to have_content(location_poll.title)

    fill_in 'Notes:', with: 'A new note'
    fill_in 'Expires:', with: ''
    click_link_or_button 'Update'

    expect(page).to have_content('Your poll has been updated.')

    visit edit_trip_path(trip)
    click_link location_poll.title
    expect(page).to have_content('A new note')
  end

  scenario 'editing a location poll' do
    visit trip_path(trip)

    within '.posts' do
      click_link_or_button generic_poll.title
    end
    
    expect(page).to have_content(generic_poll.generic_question)

  end
end
