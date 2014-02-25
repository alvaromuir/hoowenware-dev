# Testing Creating a Lodging feature

require "spec_helper"

feature "Creating a Lodging " do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }
  let!(:rsvp) { FactoryGirl.create(:rsvp, trip: trip, user: user, response: 'yes') }
  
  before do
    login_as(user, :scope => :user)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'creating a lodging itenerary from trips page' do
    visit trip_path(trip)
    within '.going' do
      click_link_or_button 'Add lodging itenerary'
    end

    select 'hotel', from: 'Lodging Type:'
    fill_in 'Name:', with: 'An Example Lodging Name'
    fill_in 'Link:', with: 'http://www.example/com/activity/xxx'
    fill_in 'Contact:', with: 'John Doe, johndoe@example.com'
    fill_in 'Checkin Date:', with: (Time.now + 30.days).strftime("%m/%d/%y")
    fill_in 'Checkin Time:', with: ((Time.now + 30.days).change({:hour => 15, :min => 00, :sec => 00 }))
                                                        .strftime("%I:%m%p")
    fill_in 'Checkout Date:', with: (Time.now + 34.days).strftime("%m/%d/%y")
    fill_in 'Address:', with: '1313 Anywhere Drive Anywhere, USA 00000'
    fill_in 'Star Rating:', with: 4.5
    fill_in 'Reviews Link:', with: 'http://www.example/com/reviews/xxx'
    fill_in 'Notes:', with: 'An Example Activity with example notes'
    fill_in 'Cover Photo:', with: 'http://www.example/com/hotels/image.jpg'

    click_link_or_button 'Create'

    expect(page).to have_content('Your lodging has been created.')
    expect(page).to have_content('View lodging itenerary')

    within '.going' do
      click_link_or_button 'View lodging itenerary'
    end

    expect(page).to have_content('hotel')
    expect(page).to have_content('An Example Lodging Name')
    expect(page).to have_content('http://www.example/com/activity/xxx')
    expect(page).to have_content('John Doe, johndoe@example.com')
    expect(page).to have_content (Time.now + 30.days).strftime("%m/%d/%y")
    expect(page).to have_content (Time.now + 34.days).strftime("%m/%d/%y")
    expect(page).to have_content('1313 Anywhere Drive Anywhere, USA 00000')
    expect(page).to have_content('4.5')
    expect(page).to have_content('http://www.example/com/reviews/xxx')
    expect(page).to have_content('An Example Activity with example notes')
    expect(page).to have_content('http://www.example/com/hotels/image.jpg')
  end
end
