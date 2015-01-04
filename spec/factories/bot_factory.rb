include WebMock::API

FactoryGirl.define do
  factory :bot do
    sequence(:name) { |n| "bot#{n}" }
    url { |n| "http://bots.example.com/#{name}"}
    game { Match::GAMES.keys.sample }
    user
    active true

    transient do
      accepts_matches true
      move_response :immediate
      times_out false
    end

    after(:create) do |bot, evaluator|
      if (evaluator.times_out)
        stub_request(:post, bot.url).to_timeout
      else
        stub_request(:post, bot.url).
          with(:body => hash_including({type: 'invite'})).
          to_return(:status => evaluator.accepts_matches ? 200 : 503)

        stub_request(:post, bot.url).
          with(:body => hash_including({type: 'move'})).
          to_return(
            :status => (evaluator.move_response == :error) ? 503 : 200,
            :body => (evaluator.move_response == :immediate) ? { 'move' => 'a4 to e7' }.to_json : nil
          )
      end
    end
  end

  trait :inactive do
    active { false }
  end
end