FactoryGirl.define do
  factory :chess do
    status { 'open' }
  end

  # factory :holdem do
  #   status { 'in progress' }
  # end

  # factory :go do
  #   status { 'in progress' }
  # end

  # factory :hearts do
  #   status { 'in progress' }
  # end

  trait :started do
    after(:create) do |m|
      m.min_participants.times do
        create(:bot, game: m.type)
      end

      m.start_match
    end
  end
end