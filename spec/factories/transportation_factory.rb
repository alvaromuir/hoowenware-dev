# transportation factory for integration testing
FactoryGirl.define do
  factory :transportation do
    transportation_type 'airline'
    service_number '999'
    seat_number '1A'
    price 299.99
    deposit_required true
    notes'An Example transportation with example notes'
    departure_city 'NYC'
    departure_date Time.now + 30.days
    departure_time Time.now + 30.days - (Time.now.min * 60)
    arrival_city 'Anywhere, USA'
    arrival_date Time.now + 30.days
    arrival_time Time.now + 30.days - (Time.now.min * 60) + 4.hours
    is_active true
  end
end