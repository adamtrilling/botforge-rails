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
      let(:bot) { FactoryGirl.create(:bot) }
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

  describe '#request_move' do
    let(:match) { FactoryGirl.create(:chess, status: 'active') }
    let(:bot) { FactoryGirl.create(:bot, move_response: move_response) }
    let(:move_response) { :immediate }

    before do
      allow(match).to receive(:execute_move)
      @retval = bot.request_move(match)
    end

    it 'sends the move to the bot' do
      expect(a_request(:post, bot.url).
        with(body: hash_including(type: 'move', match_id: match.id))).
        to have_been_made.once
    end

    context 'with a bot that immediately moves' do
      it 'sends the move to the match' do
        expect(match).to have_received(:execute_move).with('a4-e7')
      end

      it 'returns true' do
        expect(@retval).to eq true
      end
    end

    context 'with a bot that does not immediately move' do
      let(:move_response) { :delayed }

      it 'does not send anything to the match' do
        expect(match).to_not receive(:execute_move)
      end

      it 'returns true' do
        expect(@retval).to eq true
      end
    end

    context 'with a bot that errors' do
      let(:move_response) { :error }

      it 'does not send anything to the match' do
        expect(match).to_not receive(:execute_move)
      end

      it 'returns false' do
        expect(@retval).to eq false
      end
    end
  end
end
