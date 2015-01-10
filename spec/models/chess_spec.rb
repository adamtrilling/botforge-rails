require 'rails_helper'

RSpec.describe Chess, :type => :model do
  subject { Chess.new }

  describe '#setup_board' do
    before do
      subject.send(:setup_board)
    end

    it "sets the initial board layout" do
      expect(subject.state['board']).to eq [
        { 'participant' => 0, 'rank' => 'rook', 'space' => ['a', 1]},
        { 'participant' => 0, 'rank' => 'knight', 'space' => ['b', 1]},
        { 'participant' => 0, 'rank' => 'bishop', 'space' => ['c', 1]},
        { 'participant' => 0, 'rank' => 'queen', 'space' => ['d', 1]},
        { 'participant' => 0, 'rank' => 'king', 'space' => ['e', 1]},
        { 'participant' => 0, 'rank' => 'bishop', 'space' => ['f', 1]},
        { 'participant' => 0, 'rank' => 'knight', 'space' => ['g', 1]},
        { 'participant' => 0, 'rank' => 'rook', 'space' => ['h', 1]},
        { 'participant' => 0, 'rank' => 'pawn', 'space' => ['a', 2]},
        { 'participant' => 0, 'rank' => 'pawn', 'space' => ['b', 2]},
        { 'participant' => 0, 'rank' => 'pawn', 'space' => ['c', 2]},
        { 'participant' => 0, 'rank' => 'pawn', 'space' => ['d', 2]},
        { 'participant' => 0, 'rank' => 'pawn', 'space' => ['e', 2]},
        { 'participant' => 0, 'rank' => 'pawn', 'space' => ['f', 2]},
        { 'participant' => 0, 'rank' => 'pawn', 'space' => ['g', 2]},
        { 'participant' => 0, 'rank' => 'pawn', 'space' => ['h', 2]},
        { 'participant' => 1, 'rank' => 'rook', 'space' => ['a', 8]},
        { 'participant' => 1, 'rank' => 'knight', 'space' => ['b', 8]},
        { 'participant' => 1, 'rank' => 'bishop', 'space' => ['c', 8]},
        { 'participant' => 1, 'rank' => 'queen', 'space' => ['d', 8]},
        { 'participant' => 1, 'rank' => 'king', 'space' => ['e', 8]},
        { 'participant' => 1, 'rank' => 'bishop', 'space' => ['f', 8]},
        { 'participant' => 1, 'rank' => 'knight', 'space' => ['g', 8]},
        { 'participant' => 1, 'rank' => 'rook', 'space' => ['h', 8]},
        { 'participant' => 1, 'rank' => 'pawn', 'space' => ['a', 7]},
        { 'participant' => 1, 'rank' => 'pawn', 'space' => ['b', 7]},
        { 'participant' => 1, 'rank' => 'pawn', 'space' => ['c', 7]},
        { 'participant' => 1, 'rank' => 'pawn', 'space' => ['d', 7]},
        { 'participant' => 1, 'rank' => 'pawn', 'space' => ['e', 7]},
        { 'participant' => 1, 'rank' => 'pawn', 'space' => ['f', 7]},
        { 'participant' => 1, 'rank' => 'pawn', 'space' => ['g', 7]},
        { 'participant' => 1, 'rank' => 'pawn', 'space' => ['h', 7]}
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
          board: [
            { 'participant' => 0, 'rank' => 'rook', 'space' => ['a', 1]},
            { 'participant' => 0, 'rank' => 'knight', 'space' => ['b', 1]},
            { 'participant' => 0, 'rank' => 'bishop', 'space' => ['c', 1]},
            { 'participant' => 0, 'rank' => 'queen', 'space' => ['d', 1]},
            { 'participant' => 0, 'rank' => 'king', 'space' => ['e', 1]},
            { 'participant' => 0, 'rank' => 'bishop', 'space' => ['f', 1]},
            { 'participant' => 0, 'rank' => 'knight', 'space' => ['g', 1]},
            { 'participant' => 0, 'rank' => 'rook', 'space' => ['h', 1]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['a', 2]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['b', 2]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['c', 2]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['d', 2]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['e', 2]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['f', 2]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['g', 2]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['h', 2]},
            { 'participant' => 1, 'rank' => 'rook', 'space' => ['a', 8]},
            { 'participant' => 1, 'rank' => 'knight', 'space' => ['b', 8]},
            { 'participant' => 1, 'rank' => 'bishop', 'space' => ['c', 8]},
            { 'participant' => 1, 'rank' => 'queen', 'space' => ['d', 8]},
            { 'participant' => 1, 'rank' => 'king', 'space' => ['e', 8]},
            { 'participant' => 1, 'rank' => 'bishop', 'space' => ['f', 8]},
            { 'participant' => 1, 'rank' => 'knight', 'space' => ['g', 8]},
            { 'participant' => 1, 'rank' => 'rook', 'space' => ['h', 8]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['a', 7]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['b', 7]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['c', 7]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['d', 7]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['e', 7]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['f', 7]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['g', 7]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['h', 7]}
          ],
          history: [],
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
          board: [
            { 'participant' => 0, 'rank' => 'rook', 'space' => ['a', 1]},
            { 'participant' => 0, 'rank' => 'knight', 'space' => ['b', 1]},
            { 'participant' => 0, 'rank' => 'bishop', 'space' => ['c', 1]},
            { 'participant' => 0, 'rank' => 'queen', 'space' => ['d', 1]},
            { 'participant' => 0, 'rank' => 'king', 'space' => ['e', 1]},
            { 'participant' => 0, 'rank' => 'bishop', 'space' => ['f', 1]},
            { 'participant' => 0, 'rank' => 'knight', 'space' => ['g', 1]},
            { 'participant' => 0, 'rank' => 'rook', 'space' => ['h', 1]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['a', 2]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['b', 2]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['c', 2]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['d', 3]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['e', 2]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['f', 2]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['g', 2]},
            { 'participant' => 0, 'rank' => 'pawn', 'space' => ['h', 2]},
            { 'participant' => 1, 'rank' => 'rook', 'space' => ['a', 8]},
            { 'participant' => 1, 'rank' => 'knight', 'space' => ['b', 8]},
            { 'participant' => 1, 'rank' => 'bishop', 'space' => ['c', 8]},
            { 'participant' => 1, 'rank' => 'queen', 'space' => ['d', 8]},
            { 'participant' => 1, 'rank' => 'king', 'space' => ['e', 8]},
            { 'participant' => 1, 'rank' => 'bishop', 'space' => ['f', 8]},
            { 'participant' => 1, 'rank' => 'knight', 'space' => ['g', 8]},
            { 'participant' => 1, 'rank' => 'rook', 'space' => ['h', 8]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['a', 7]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['b', 7]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['c', 7]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['d', 7]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['e', 7]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['f', 7]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['g', 7]},
            { 'participant' => 1, 'rank' => 'pawn', 'space' => ['h', 7]}
          ],
          history: ['d3'],
          next_to_move: 1,
          legal_moves: [
            'a6', 'a5', 'b6', 'b5', 'c6', 'c5',
            'd6', 'd5', 'e6', 'e5', 'f6', 'f5',
            'g6', 'g5', 'h6', 'h5', 'na6', 'nc6',
            'nf6', 'nh6'
          ]
        },
        other_player_legal_moves: [
          'a3', 'a4', 'b3', 'b4', 'c3', 'c4',
          'd4', 'e3', 'e4', 'f3', 'f4',
          'g3', 'g4', 'h3', 'h4', 'na3', 'nc3',
          'nd2', 'nf3', 'nh3'
        ]
      }
    ].each do |name, test|
      context name do
        before do
          subject.update_attributes(state: test[:state_before])
          subject.execute_move(test[:move])
        end

        it 'should have the correct board' do
          expect(subject.state['board']).to eq test[:state_after][:board]
        end

        it 'should include the move in the history' do
          expect(subject.state['history'].last).to eq test[:move]
        end

        it 'should have the correct next to move' do
          expect(subject.state['next_to_move']).to eq test[:state_after][:next_to_move]
        end

        it 'should have the correct legal moves for the other player' do
          subject.state['legal_moves'].each do |move|
            expect(test[:state_after][:legal_moves]).to include(move)
          end

          test[:state_after][:legal_moves].each do |move|
            expect(subject.state['legal_moves']).to include(move)
          end
        end

        # testing the private API beacuse it halves the number of test cases
        it 'should have the correct moves for the current player`' do
          current_player_legal_moves = subject.send(:legal_moves, (subject.state['next_to_move'] + 1) % 2)

          current_player_legal_moves.each do |move|
            expect(test[:other_player_legal_moves]).to include(move)
          end

          test[:other_player_legal_moves].each do |move|
            expect(current_player_legal_moves).to include(move)
          end
        end
      end
    end
  end
end
