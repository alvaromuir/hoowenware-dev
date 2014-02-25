# Testing Editing Transportation feature

require "spec_helper"

feature "Editing Transportation feature" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:rsvp) { FactoryGirl.create(:rsvp, trip: trip, user: user, response: 'yes') }
  let!(:transportation) { FactoryGirl.create(:transportation, trip: trip, user: user) }

  before do
    login_as(user, :scope => :user)
    visit trip_path(trip)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'editing a transportation record from trips page' do
    login_as(user, :scope => :user)
    visit trip_path(trip)

    within '.going' do
      click_link_or_button 'View travel itenerary'
    end

    click_link_or_button 'Update travel itenerary'

    fill_in 'Service Number:', with: '54'
    fill_in 'Seat Number:', with: '5C'
    fill_in 'Price:', with: '345'
    fill_in 'Notes:', with: 'Updated details.'
    fill_in 'Departure Time:', with: ((trip.start_date)
                                      .change({:hour=>19, min: 30}))
                                      .strftime("%I:%m%p")
    fill_in 'Arrival Time:', with: ((trip.start_date)
                                      .change({:hour=>21, min: 30}))
                                      .strftime("%I:%m%p")

    click_link_or_button 'Update'

    expect(page).to have_content('Your travel arrangements have been updated.')

    visit trip_path(trip)

    within '.going' do
      click_link_or_button 'View travel itenerary'
    end
    
    expect(page).to have_content('54')
    expect(page).to have_content('5C')
    expect(page).to have_content('345')
    expect(page).to have_content('Updated details.')
  end

  scenario 'editing a transportation record from user profile page' do
    login_as(user, :scope => :user)
    visit user_path(user)

    within '.travel-plans' do
      click_link_or_button transportation.transportation_type
    end

    click_link_or_button 'Update travel itenerary'

    fill_in 'Service Number:', with: '54'
    fill_in 'Seat Number:', with: '5C'
    fill_in 'Price:', with: '345'
    fill_in 'Notes:', with: 'Updated details.'
    fill_in 'Departure Time:', with: ((trip.start_date)
                                      .change({:hour=>19, min: 30}))
                                      .strftime("%I:%m%p")
    fill_in 'Arrival Time:', with: ((trip.start_date)
                                      .change({:hour=>21, min: 30}))
                                      .strftime("%I:%m%p")

    click_link_or_button 'Update'

    expect(page).to have_content('Your travel arrangements have been updated.')

    visit user_path(user)
    within '.travel-plans' do
      click_link_or_button transportation.transportation_type
    end

    expect(page).to have_content('54')
    expect(page).to have_content('5C')
    expect(page).to have_content('345')
    expect(page).to have_content('Updated details.')


  end
end
