# Testing the trip creation feature
require 'spec_helper'

feature 'Creating Trips' do
  before do
    user = FactoryGirl.create(:user)

    visit '/trips/new'
    message = "You need to sign in or sign up before continuing."
    expect(page).to have_content(message)

    within '#sign_in_form' do
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
    end

    click_button "Sign in"
    visit '/trips/new'
  end


  scenario "can create an trip" do


    within '#new_trip_form' do
      fill_in 'Trip Title:', with: 'Example Trip'
      fill_in 'Hashtag:', with: '#ExampleHashTag'
      fill_in 'Start', with: (Time.now + 30.days).strftime("%m/%d/%y")
      fill_in 'End', with: (Time.now + 34.days).strftime("%m/%d/%y")
      fill_in 'Location', with: 'Anywhere, USA'
      select 'private', from: 'Privacy'
      check 'Hide Guestlist?'
    end

    click_link_or_button 'Create'
    
    expect(page).to have_content('Your trip has been created.')

    trip = Trip.where(title: 'Example Trip').first
    expect(page.current_url).to eql(trip_url(trip))

    title = "Example Trip - Trips - Hoowenware"
    expect(page).to have_title(title)

    within "#trip .creator" do
      user = trip.user
      expect(page).to have_content("Planned by ", user)
    end
  end

  scenario "can't create trips without basic attributes" do
    # skip Title field
    click_link_or_button 'Create'
    expect(page).to have_content("Your trip has not been created.")
    expect(page).to have_content("Title can't be blank")

    # skip start date
    within '#new_trip_form' do
      fill_in 'Trip Title:', with: 'Example Trip'
      click_link_or_button 'Create'
    end

    expect(page).to have_content("Your trip has not been created.")
    expect(page).to have_content("Start date can't be blank")

    # skip end date
    within '#new_trip_form' do
      fill_in 'Trip Title:', with: 'Example Trip'
      fill_in 'Start', with: (Time.now + 30.days).strftime("%m/%d/%y")
      click_link_or_button 'Create'
    end

    expect(page).to have_content("Your trip has not been created.")
    expect(page).to have_content("End date can't be blank")

    # skip location
    within '#new_trip_form' do
      fill_in 'Trip Title:', with: 'Example Trip'
      fill_in 'Start', with: (Time.now + 30.days).strftime("%m/%d/%y")
      fill_in 'End', with: (Time.now + 34.days).strftime("%m/%d/%y")
      click_link_or_button 'Create'
    end

    expect(page).to have_content("Your trip has not been created.")
    expect(page).to have_content("Location can't be blank")

    # input all required fields
    within '#new_trip_form' do
      fill_in 'Trip Title:', with: 'Example Trip'
      fill_in 'Start', with: (Time.now + 30.days).strftime("%m/%d/%y")
      fill_in 'End', with: (Time.now + 34.days).strftime("%m/%d/%y")
      fill_in 'Location', with: 'Anywhere, USA'
      click_link_or_button 'Create'
    end
    
    expect(page).to have_content('Your trip has been created.')
    expect(page).to have_content('Example Trip')
    expect(page).to have_content (Time.now + 30.days).strftime("%m/%d/%y")
    expect(page).to have_content (Time.now + 34.days).strftime("%m/%d/%y")
    expect(page).to have_content('Anywhere, USA')

  end

end