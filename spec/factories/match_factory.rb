FactoryGirl.define do
  factory :chess do
    email { Faker::Internet.email }
  end
end