# room factory for integration testing

FactoryGirl.define do
  factory :room do
    name 'An Example Room Name'
    price 199.99
    min_stay 2
    room_type 'Double Queen'
    amenities 'Some wallpaper, coffemaker and windbreakers'
    deadline (Time.now + 30.days).strftime("%m/%d/%y") 
    deposit 45.00
    cc_required true
    min_age 21
    room_gender 'female'
    notes 'Some notes about the room will go here, I guess?'
    sleeps 4
    is_active true
  end
end