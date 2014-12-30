include WebMock::API

FactoryGirl.define do
  factory :bot do
    sequence(:name) { |n| "bot#{n}" }
    url { |n| "http://bots.example.com/#{name}"}
    game { Match::GAMES.keys.sample }
    active { true }
  end

  trait :accepts_matches do
    after(:create) do |b|
      stub_request(:post, b.url).
        with(:body => hash_including({type: 'invite'})).
        to_return(:status => 200)
    end
  end

  trait :declines_matches do
    after(:create) do |b|
      stub_request(:post, b.url).
        with(:body => hash_including({type: 'invite'})).
        to_return(:status => 503)
    end
  end

  trait :inactive do
    active { false }
  end
end