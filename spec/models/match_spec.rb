require 'rails_helper'

RSpec.describe Match, :type => :model do

  specify do
    should have_many(:participants)

    should validate_inclusion_of(:type).in_array(Match::GAMES.keys)
  end

  describe '#invite_participants' do
    subject { FactoryGirl.create(Match::GAMES.keys.sample.downcase.to_sym) }

    before do
      allow(subject.class).to receive(:expected_participants).and_return(3)
    end

    context 'when there are enough players available' do
      before do
        3.times do
          FactoryGirl.create(:bot, game: subject.type)
        end

        @retval = subject.invite_participants
      end

      it 'returns true' do
        expect(@retval).to eq true
      end

      it 'fills all spots' do
        expect(subject.has_participants?).to eq true
      end
    end

    context 'when there are not enough players available' do
      before do
        2.times do
          FactoryGirl.create(:bot, game: subject.type)
        end

        @retval = subject.invite_participants
      end

      it 'returns false' do
        expect(@retval).to eq false
      end

      it 'doesn\'t fill all spots' do
        expect(subject.has_participants?).to eq false
      end
    end

    context 'when there are enough players available but some of them decline' do
      before do
        2.times do
          FactoryGirl.create(:bot, game: subject.type)
        end
        FactoryGirl.create(:bot, accepts_matches: false, game: subject.type)

        @retval = subject.invite_participants
      end

      it 'returns false' do
        expect(@retval).to eq false
      end

      it 'doesn\'t fill all spots' do
        expect(subject.has_participants?).to eq false
      end
    end

    context 'when there are enough players but some are inactive' do
      before do
        2.times do
          FactoryGirl.create(:bot, game: subject.type)
        end
        FactoryGirl.create(:bot, :inactive, game: subject.type)

        @retval = subject.invite_participants
      end

      it 'returns false' do
        expect(@retval).to eq false
      end

      it 'doesn\'t fill all spots' do
        expect(subject.has_participants?).to eq false
      end
    end
  end

  describe '#has_participants?' do
    subject { Match.new }

    before do
      allow(subject.class).to receive(:expected_participants).and_return(num_players)
    end

    context 'when the number of participants is fixed' do
      let(:num_players) { 2 }

      it 'doesn\'t allow too few players' do
        (num_players - 1).times do
          subject.participants.build
        end
        expect(subject.has_participants?).to eq false
      end

      it 'doesn\'t allow too many players' do
        (num_players + 1).times do
          subject.participants.build
        end
        expect(subject.has_participants?).to eq false
      end

      it 'allows the right number of players' do
        (num_players).times do
          subject.participants.build
        end
        expect(subject.has_participants?).to eq true
      end
    end
  end

  describe 'request_move' do
    subject { FactoryGirl.create(Match::GAMES.keys.sample.downcase.to_sym, :started) }

    before do

    end
  end
end
