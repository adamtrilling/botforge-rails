FactoryGirl.define do
  factory :bot do
    sequence(:name) { |n| "bot#{n}" }
    url { |n| "http://bots.example.com/#{name}"}
    game { 'global thermonuclear war' }
  end
end