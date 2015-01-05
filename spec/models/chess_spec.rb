require 'rails_helper'

RSpec.describe Chess, :type => :model do
  subject { Chess.new }

  describe '#setup_board' do
    before do
      subject.send(:setup_board)
    end

    it "sets the initial board layout" do
      expect(subject.state['board']).to eq Hash[
        '0' => [
          { 'rank' => 'R', 'space' => ['a', '1']},
          { 'rank' => 'N', 'space' => ['b', '1']},
          { 'rank' => 'B', 'space' => ['c', '1']},
          { 'rank' => 'Q', 'space' => ['d', '1']},
          { 'rank' => 'K', 'space' => ['e', '1']},
          { 'rank' => 'B', 'space' => ['f', '1']},
          { 'rank' => 'N', 'space' => ['g', '1']},
          { 'rank' => 'R', 'space' => ['h', '1']},
          { 'rank' => 'P', 'space' => ['a', '2']},
          { 'rank' => 'P', 'space' => ['b', '2']},
          { 'rank' => 'P', 'space' => ['c', '2']},
          { 'rank' => 'P', 'space' => ['d', '2']},
          { 'rank' => 'P', 'space' => ['e', '2']},
          { 'rank' => 'P', 'space' => ['f', '2']},
          { 'rank' => 'P', 'space' => ['g', '2']},
          { 'rank' => 'P', 'space' => ['h', '2']}
        ],
        '1' => [
          { 'rank' => 'R', 'space' => ['a', '8']},
          { 'rank' => 'N', 'space' => ['b', '8']},
          { 'rank' => 'B', 'space' => ['c', '8']},
          { 'rank' => 'Q', 'space' => ['d', '8']},
          { 'rank' => 'K', 'space' => ['e', '8']},
          { 'rank' => 'B', 'space' => ['f', '8']},
          { 'rank' => 'N', 'space' => ['g', '8']},
          { 'rank' => 'R', 'space' => ['h', '8']},
          { 'rank' => 'P', 'space' => ['a', '7']},
          { 'rank' => 'P', 'space' => ['b', '7']},
          { 'rank' => 'P', 'space' => ['c', '7']},
          { 'rank' => 'P', 'space' => ['d', '7']},
          { 'rank' => 'P', 'space' => ['e', '7']},
          { 'rank' => 'P', 'space' => ['f', '7']},
          { 'rank' => 'P', 'space' => ['g', '7']},
          { 'rank' => 'P', 'space' => ['h', '7']}
        ]
      ]
    end

    it 'creates an empty move history' do
      expect(subject.state['history']).to eq []
    end

    it 'sets white as next to move' do
      expect(subject.state['next_to_move']).to eq 0
    end

    it 'sets the initial legal moves for white' do
      expect(subject.state['legal_moves']).to eq [
        'a3', 'a4', 'b3', 'b4', 'c3', 'c4',
        'd3', 'd4', 'e3', 'e4', 'f3', 'f4',
        'g3', 'g4', 'h3', 'h4', 'na3', 'nc3',
        'nf3', 'nh3'
      ]
    end
  end

  describe '#execute_move' do
    subject {
      FactoryGirl.create(:chess, :started)
    }

    Hash[
      'white pawn moves one space' => {
        state_before: {
          board: {
            '0' => [
              { 'rank' => 'R', 'space' => ['a', '1']},
              { 'rank' => 'N', 'space' => ['b', '1']},
              { 'rank' => 'B', 'space' => ['c', '1']},
              { 'rank' => 'Q', 'space' => ['d', '1']},
              { 'rank' => 'K', 'space' => ['e', '1']},
              { 'rank' => 'B', 'space' => ['f', '1']},
              { 'rank' => 'N', 'space' => ['g', '1']},
              { 'rank' => 'R', 'space' => ['h', '1']},
              { 'rank' => 'P', 'space' => ['a', '2']},
              { 'rank' => 'P', 'space' => ['b', '2']},
              { 'rank' => 'P', 'space' => ['c', '2']},
              { 'rank' => 'P', 'space' => ['d', '2']},
              { 'rank' => 'P', 'space' => ['e', '2']},
              { 'rank' => 'P', 'space' => ['f', '2']},
              { 'rank' => 'P', 'space' => ['g', '2']},
              { 'rank' => 'P', 'space' => ['h', '2']}
            ],
            '1' => [
              { 'rank' => 'R', 'space' => ['a', '8']},
              { 'rank' => 'N', 'space' => ['b', '8']},
              { 'rank' => 'B', 'space' => ['c', '8']},
              { 'rank' => 'Q', 'space' => ['d', '8']},
              { 'rank' => 'K', 'space' => ['e', '8']},
              { 'rank' => 'B', 'space' => ['f', '8']},
              { 'rank' => 'N', 'space' => ['g', '8']},
              { 'rank' => 'R', 'space' => ['h', '8']},
              { 'rank' => 'P', 'space' => ['a', '7']},
              { 'rank' => 'P', 'space' => ['b', '7']},
              { 'rank' => 'P', 'space' => ['c', '7']},
              { 'rank' => 'P', 'space' => ['d', '7']},
              { 'rank' => 'P', 'space' => ['e', '7']},
              { 'rank' => 'P', 'space' => ['f', '7']},
              { 'rank' => 'P', 'space' => ['g', '7']},
              { 'rank' => 'P', 'space' => ['h', '7']}
            ]
          },
          move_history: [],
          next_to_move: 0,
          legal_moves: [
            'a3', 'a4', 'b3', 'b4', 'c3', 'c4',
            'd3', 'd4', 'e3', 'e4', 'f3', 'f4',
            'g3', 'g4', 'h3', 'h4', 'na3', 'nc3',
            'nf3', 'nh3'
          ]
        },
        move: 'd3',
        state_after: {
          board: {
            '0' => [
              { 'rank' => 'R', 'space' => ['a', '1']},
              { 'rank' => 'N', 'space' => ['b', '1']},
              { 'rank' => 'B', 'space' => ['c', '1']},
              { 'rank' => 'Q', 'space' => ['d', '1']},
              { 'rank' => 'K', 'space' => ['e', '1']},
              { 'rank' => 'B', 'space' => ['f', '1']},
              { 'rank' => 'N', 'space' => ['g', '1']},
              { 'rank' => 'R', 'space' => ['h', '1']},
              { 'rank' => 'P', 'space' => ['a', '2']},
              { 'rank' => 'P', 'space' => ['b', '2']},
              { 'rank' => 'P', 'space' => ['c', '2']},
              { 'rank' => 'P', 'space' => ['d', '3']},
              { 'rank' => 'P', 'space' => ['e', '2']},
              { 'rank' => 'P', 'space' => ['f', '2']},
              { 'rank' => 'P', 'space' => ['g', '2']},
              { 'rank' => 'P', 'space' => ['h', '2']}
            ],
            '1' => [
              { 'rank' => 'R', 'space' => ['a', '8']},
              { 'rank' => 'N', 'space' => ['b', '8']},
              { 'rank' => 'B', 'space' => ['c', '8']},
              { 'rank' => 'Q', 'space' => ['d', '8']},
              { 'rank' => 'K', 'space' => ['e', '8']},
              { 'rank' => 'B', 'space' => ['f', '8']},
              { 'rank' => 'N', 'space' => ['g', '8']},
              { 'rank' => 'R', 'space' => ['h', '8']},
              { 'rank' => 'P', 'space' => ['a', '7']},
              { 'rank' => 'P', 'space' => ['b', '7']},
              { 'rank' => 'P', 'space' => ['c', '7']},
              { 'rank' => 'P', 'space' => ['d', '7']},
              { 'rank' => 'P', 'space' => ['e', '7']},
              { 'rank' => 'P', 'space' => ['f', '7']},
              { 'rank' => 'P', 'space' => ['g', '7']},
              { 'rank' => 'P', 'space' => ['h', '7']}
            ]
          },
          move_history: ['d3'],
          next_to_move: 1,
          legal_moves: [
            'a6', 'a5', 'b6', 'b5', 'c6', 'c5',
            'd6', 'd5', 'e6', 'e5', 'f6', 'f5',
            'g6', 'g5', 'h6', 'h5', 'na6', 'nc6',
            'nf6', 'nh6'
          ]
        }

      }
    ].each do |name, test|
      context name do
        before do
          subject.update_attributes(state: test[:state_before])
          subject.execute_move(test[:move])
        end

        it 'should have the correct board' do
          expect(subject.state['board']).to eq test[:state_after]['board']
        end

        it 'should include the move in the history' do
          expect(subject.state['history'].last).to eq test[:move]
        end

        it 'should have the correct next to move' do
          expect(subject.state['next_to_move']).to eq test[:state_after]['next_to_move']
        end

        it 'should have the correct legal moves' do
          expect(subject.state['legal_moves']).to eq test[:state_after]['legal_moves']
        end
      end
    end
  end
end
