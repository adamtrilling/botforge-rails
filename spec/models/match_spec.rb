require 'rails_helper'

RSpec.describe Match, :type => :model do

  specify do
    should have_many(:participants)

    should validate_inclusion_of(:type).in_array(Match::GAMES.keys)
  end

  describe '#invite_participants' do
    subject { FactoryGirl.create(Match::GAMES.keys.sample.downcase.to_sym) }

    before do
      allow(subject).to receive(:num_players).and_return(3)
    end

    context 'when there are enough players available' do
      before do
        3.times do
          FactoryGirl.create(:bot, :accepts_matches, game: subject.type)
        end

        subject.invite_participants
      end

      it 'fills all spots' do
        expect(subject.has_participants?).to eq true
      end
    end

    context 'when there are not enough players available' do
      before do
        2.times do
          FactoryGirl.create(:bot, :accepts_matches, game: subject.type)
        end

        subject.invite_participants
      end

      it 'doesn\'t fill all spots' do
        expect(subject.has_participants?).to eq false
      end
    end

    context 'when there are enough players available but some of them decline' do
      before do
        2.times do
          FactoryGirl.create(:bot, :accepts_matches, game: subject.type)
        end
        FactoryGirl.create(:bot, :declines_matches, game: subject.type)

        subject.invite_participants
      end

      it 'doesn\'t fill all spots' do
        expect(subject.has_participants?).to eq false
      end
    end
  end

  describe '#has_participants?' do
    subject { Match.new }

    before do
      allow(subject).to receive(:num_players).and_return(num_players)
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
end
