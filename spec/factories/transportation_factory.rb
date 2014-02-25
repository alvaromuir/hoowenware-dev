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
    departure_time (Time.now + 30.days).change({:hour => 15, :min => 0})
    arrival_city 'Anywhere, USA'
    arrival_date Time.now + 30.days
    arrival_time (Time.now + 30.days).change({:hour => 18, :min => 45})
    is_active true
  end
end