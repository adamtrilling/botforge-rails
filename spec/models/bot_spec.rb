require 'rails_helper'

RSpec.describe Bot, :type => :model do
  specify do
    should belong_to(:user)
    should validate_presence_of(:game)
    should validate_presence_of(:url)
  end

  describe '#url' do
    it 'allows valid urls' do
      should allow_value('http://foo.com', 'https://foo.com/bar').
        for(:url)
      should_not allow_value('ftp://foo.com', 'foo.bar/baz', 'abc@example.com').
        for(:url)
    end
  end

  describe '#invite' do
    context 'with a bot that accepts matches' do
      let(:bot) { FactoryGirl.create(:bot, :accepts_matches) }
      let(:match) { FactoryGirl.create(:chess, status: 'on hold') }

      before do
        @retval = bot.invite(match)
      end

      it 'sends a match invite to the bot' do
        expect(a_request(:post, bot.url).
          with(body: hash_including(type: 'invite', match_id: match.id, game: match.type))).
          to have_been_made.once
      end

      it 'returns true' do
        expect(@retval).to eq true
      end
    end
  end
end
