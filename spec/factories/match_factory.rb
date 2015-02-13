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

  trait :has_players do
    after(:create) do |m|
      m.min_participants.times do |i|
        Participant.create(
          match_id: m.id,
          player_id: create(:bot, game: m.type).id,
          seat: i
        )
      end
    end
  end

  trait :started do
    has_players

    after(:create) do |m|
      m.start_match
    end
  end
end