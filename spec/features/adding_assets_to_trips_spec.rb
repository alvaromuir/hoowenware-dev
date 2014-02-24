# Testing Uploading Assets to Trips feature

require "spec_helper"

feature "Uploading Assets to Trips" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:trip) { FactoryGirl.create(:trip, user: user) }

  before do
    login_as(user, :scope => :user)
  end

  after do
    logout(:user)
    Warden.test_reset!
  end

  scenario 'creating a trip with assets', js: true do
    visit '/trips/new'


    fill_in 'Trip Title:', with: 'Example Trip'
    fill_in 'Hashtag:', with: '#ExampleHashTag'
    fill_in 'Start', with: '03/01/2013'
    fill_in 'End', with: '03/03/2013'
    fill_in 'Location', with: 'Anywhere, USA'
    select 'private', from: 'Privacy'
    check 'Hide Guestlist?'

    attach_file "File #1", Rails.root.join("spec/fixtures/test.jpg")

    click_link_or_button "Add another file"
    attach_file "File #2", Rails.root.join("spec/fixtures/test.ics")

    click_link_or_button "Add another file"
    attach_file "File #3", Rails.root.join("spec/fixtures/test.pdf")

    click_link_or_button 'Create'
    
    expect(page).to have_content('Your trip has been created.')

    within(".assets") do
      expect(page).to have_content('test.jpg')
      expect(page).to have_content('test.ics')
      expect(page).to have_content('test.pdf')
    end
  end

  scenario 'adding assets to a trip', js: true do
    visit trip_path(trip)

    click_link_or_button 'Add a photo'
    attach_file "File #1", Rails.root.join("spec/fixtures/test-upload.jpg")
    
    click_link_or_button 'Upload'
    expect(page).to have_content('Your trip has been updated.')

    within(".assets") do
      expect(page).to have_content('test-upload.jpg')
    end

  end

end
