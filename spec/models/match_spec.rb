require 'rails_helper'

RSpec.describe Match, :type => :model do

  specify do
    should have_many(:participants)

    should validate_inclusion_of(:type).in_array(Match::GAMES.keys)
  end

  describe '#invite_participants' do

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
