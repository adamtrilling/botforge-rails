FactoryGirl.define do
  factory :human do
    user
    game { Match::GAMES.keys.sample }
  end
end