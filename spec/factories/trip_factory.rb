# event factory for integration testing

FactoryGirl.define do
  start = ''
	factory :trip do
    title { generate(:trip_title) }
    sequence(:start_date) {|n| start = gen_random_date }
    sequence(:end_date) {|n| gen_random_date(start) }
    sequence(:location) {|n| "Location ##{n}"}
	end
end