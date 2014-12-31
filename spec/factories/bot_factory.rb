include WebMock::API

FactoryGirl.define do
  factory :bot do
    sequence(:name) { |n| "bot#{n}" }
    url { |n| "http://bots.example.com/#{name}"}
    game { Match::GAMES.keys.sample }
    active true

    transient do
      accepts_matches true
    end

    after(:create) do |bot, evaluator|
      stub_request(:post, bot.url).
        with(:body => hash_including({type: 'invite'})).
        to_return(:status => evaluator.accepts_matches ? 200 : 503)
    end
  end

  trait :inactive do
    active { false }
  end
end