FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    sequence(:username) { |n| "person#{n}" }
    password { 'password1' }
  end
end