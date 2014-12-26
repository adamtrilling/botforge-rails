require 'rails_helper'

describe User do
  specify do
    should have_many(:bots)
    should have_many(:humans)
  end

  describe '#set_confirmation_token' do
    before do
      @user = FactoryGirl.create(:user)
      @token = @user.set_confirmation_token
    end

    it 'returns the confirmation token' do
      expect(@token).to_not be_nil
    end

    it 'encrypts the token in the database' do
      expect(@user.confirmation_token).to_not be_nil
      expect(@user.confirmation_token.to_s).to_not eq @token
    end
  end

  describe '#human_for' do
    let(:game) { Match::GAMES.keys.sample }

    context 'when the user hasn\'t played the game before' do
      let(:user) { FactoryGirl.create(:user) }

      before do
        @human_count = Human.count
        @human = user.human_for(game)
      end

      it 'creates a human player with the right game' do
        expect(@human.user.id).to eq user.id
        expect(Human.count - 1).to eq @human_count
        expect(@human.game).to eq game
      end
    end

    context 'when a user has played the game before' do
      let!(:user) { FactoryGirl.create(:user, humans: [FactoryGirl.create(:human, game: game)]) }

      before do
        @human_count = Human.count
        @human = user.human_for(game)
      end

      it 'finds a human player with the right game' do
        expect(@human.user.id).to eq user.id
        expect(Human.count).to eq @human_count
        expect(@human.game).to eq game
      end
    end
  end
end