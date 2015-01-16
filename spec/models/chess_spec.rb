require 'rails_helper'

RSpec.describe Chess, :type => :model do
  subject { Chess.new }
  initial_board = 'rnbqkbnrpppppppp' + ('.' * 32) + 'PPPPPPPPRNBQKBNR'

  describe '#setup_board' do
    before do
      subject.send(:setup_board)
    end

    it "sets the initial board layout" do
      expect(subject.state['board']).to eq initial_board
    end

    it 'creates an empty move history' do
      expect(subject.state['history']).to eq []
    end

    it 'sets white as next to move' do
      expect(subject.state['next_to_move']).to eq 0
    end

    it 'sets the initial legal moves for white' do
      expect(subject.state['legal_moves']).to eq [
        'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
        'd2-d3', 'd2-d4', 'e2-e3', 'e2-e4', 'f2-f3', 'f2-f4',
        'g2-g3', 'g2-g4', 'h2-h3', 'h2-h4', 'b2-a3', 'b2-c3',
        'g2-f3', 'g2-h3'
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
          board: initial_board,
          history: [],
          next_to_move: 0,
          legal_moves: [
            'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
            'd2-d3', 'd2-d4', 'e2-e3', 'e2-e4', 'f2-f3', 'f2-f4',
            'g2-g3', 'g2-g4', 'h2-h3', 'h2-h4', 'b2-a3', 'b2-c3',
            'g2-f3', 'g2-h3'
          ]
        },
        move: 'd2-d3',
        state_after: {
          board: 'rnbqkbnr' +
                 'ppp.pppp' +
                 '...p....' +
                 '........' +
                 '........' +
                 '........' +
                 'PPPPPPPP' +
                 'RNBQKBNR',
          history: ['d2-d3'],
          next_to_move: 1,
          legal_moves: [
            'a7-a6', 'a7-a5', 'b7-b6', 'b7-b5', 'c7-c6', 'c7-c5',
            'd7-d6', 'd7-d5', 'e7-e6', 'e7-e5', 'f7-f6', 'f7-f5',
            'g7-g6', 'g7-g5', 'h7-h6', 'h7-h5', 'b8-a6', 'b8-c6',
            'g8-f6', 'g8-h6'
          ]
        },
        other_player_legal_moves: [
          'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
          'd3-d4', 'e2-e3', 'e2-e4', 'f2-f3', 'f2-f4',
          'g2-g3', 'g2-g4', 'h2-h3', 'h2-h4', 'b1-a3', 'b1-c3', 'b1-d2',
          'g1-f3', 'g1-h3'
        ]
      },
      'white pawn moves two spaces' => {
        state_before: {
          board: initial_board,
          history: [],
          next_to_move: 0,
          legal_moves: [
            'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
            'd2-d3', 'd2-d4', 'e2-e3', 'e2-e4', 'f2-f3', 'f2-f4',
            'g2-g3', 'g2-g4', 'h2-h3', 'h2-h4', 'b2-a3', 'b2-c3',
            'g2-f3', 'g2-h3'
          ]
        },
        move: 'd2-d4',
        state_after: {
          board: 'rnbqkbnr' +
                 'ppp.pppp' +
                 '........' +
                 '...p....' +
                 '........' +
                 '........' +
                 'PPPPPPPP' +
                 'RNBQKBNR',
          history: ['d2-d4'],
          next_to_move: 1,
          legal_moves: [
            'a7-a6', 'a7-a5', 'b7-b6', 'b7-b5', 'c7-c6', 'c7-c5',
            'd7-d6', 'd7-d5', 'e7-e6', 'e7-e5', 'f7-f6', 'f7-f5',
            'g7-g6', 'g7-g5', 'h7-h6', 'h7-h5', 'b8-a6', 'b8-c6',
            'g8-f6', 'g8-h6'
          ]
        },
        other_player_legal_moves: [
          'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
          'd4-d5', 'e2-e3', 'e2-e4', 'f2-f3', 'f2-f4',
          'g2-g3', 'g2-g4', 'h2-h3', 'h2-h4', 'b1-a3', 'b1-c3', 'b1-d2',
          'g1-f3', 'g1-h3'
        ]
      },
      'black pawn moves one space' => {
        state_before: {
          board: 'rnbqkbnr' +
                 'ppp.pppp' +
                 '........' +
                 '...p....' +
                 '........' +
                 '........' +
                 'PPPPPPPP' +
                 'RNBQKBNR',
          history: ['d4'],
          next_to_move: 1,
          legal_moves: [
            'a7-a6', 'a7-a5', 'b7-b6', 'b7-b5', 'c7-c6', 'c7-c5',
            'd7-d6', 'd7-d5', 'e7-e6', 'e7-e5', 'f7-f6', 'f7-f5',
            'g7-g6', 'g7-g5', 'h7-h6', 'h7-h5', 'b8-a6', 'b8-c6',
            'g8-f6', 'g8-h6'
          ]
        },
        move: 'd7-d6',
        state_after: {
          board: 'rnbqkbnr' +
                 'ppp.pppp' +
                 '........' +
                 '...p....' +
                 '........' +
                 '...P....' +
                 'PPP.PPPP' +
                 'RNBQKBNR',
          history: ['d2-d4', 'd7-d6'],
          next_to_move: 0,
          legal_moves: [
            'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
            'd4-d5', 'e2-e3', 'e2-e4', 'f2-f3', 'f2-f4',
            'g2-g3', 'g2-g4', 'h2-h3', 'h2-h4', 'b1-a3', 'b1-c3', 'b1-d2',
            'g1-f3', 'g1-h3'
          ]
        },
        other_player_legal_moves: [
          'a7-a6', 'a7-a5', 'b7-b6', 'b7-b5', 'c7-c6', 'c7-c5',
          'd6-d5', 'e7-e6', 'e7-e5', 'f7-f6', 'f7-f5',
          'g7-g6', 'g7-g5', 'h7-h6', 'h7-h5', 'b8-a6', 'b8-c6', 'b8-d7',
          'g8-f6', 'g8-h6'
        ]
      },
      'black pawn moves two spaces' => {
        state_before: {
          board: 'rnbqkbnr' +
                 'ppp.pppp' +
                 '........' +
                 '...p....' +
                 '........' +
                 '........' +
                 'PPPPPPPP' +
                 'RNBQKBNR',
          history: ['d2-d4'],
          next_to_move: 1,
          legal_moves: [
            'a7-a6', 'a7-a5', 'b7-b6', 'b7-b5', 'c7-c6', 'c7-c5',
            'd7-d6', 'd7-d5', 'e7-e6', 'e7-e5', 'f7-f6', 'f7-f5',
            'g7-g6', 'g7-g5', 'h7-h6', 'h7-h5', 'b8-a6', 'b8-c6',
            'g8-f6', 'g8-h6'
          ]
        },
        move: 'd7-d5',
        state_after: {
          board: 'rnbqkbnr' +
                 'ppp.pppp' +
                 '........' +
                 '...p....' +
                 '...P....' +
                 '........' +
                 'PPP.PPPP' +
                 'RNBQKBNR',
          history: ['d2-d4', 'd7-d5'],
          next_to_move: 0,
          legal_moves: [
            'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
            'e2-e3', 'e2-e4', 'f2-f3', 'f2-f4', 'g2-g3', 'g2-g4',
            'h2-h3', 'h2-h4', 'b1-a3', 'b1-c3', 'b1-d2',
            'g1-f3', 'g1-h3'
          ]
        },
        other_player_legal_moves: [
          'a7-a6', 'a7-a5', 'b7-b6', 'b7-b5', 'c7-c6', 'c7-c5',
          'e7-e6', 'e7-e5', 'f7-f6', 'f7-f5', 'g7-g6', 'g7-g5',
          'h7-h6', 'h7-h5', 'b8-a6', 'b8-c6', 'b8-d7',
          'g8-f6', 'g8-h6'
        ]
      },
      'white pawn threatens capture' => {
        state_before: {
          board: 'rnbqkbnr' +
                 'ppp.pppp' +
                 '........' +
                 '...p....' +
                 '...P....' +
                 '........' +
                 'PPP.PPPP' +
                 'RNBQKBNR',
          history: ['d2-d4', 'd7-d5'],
          next_to_move: 0,
          legal_moves: [
            'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
            'e2-e3', 'e2-e4', 'f2-f3', 'f2-f4', 'g2-g3', 'g2-g4',
            'h2-h3', 'h2-h4', 'b1-a3', 'b1-c3', 'b1-d2',
            'g1-f3', 'g1-h3'
          ]
        },
        move: 'e2-e4',
        state_after: {
          board: 'rnbqkbnr' +
                 'ppp..ppp' +
                 '........' +
                 '...pp...' +
                 '...P....' +
                 '........' +
                 'PPP.PPPP' +
                 'RNBQKBNR',
          history: ['d2-d4', 'd7-d5', 'e2-e4'],
          next_to_move: 1,
          legal_moves: [
            'a7-a6', 'a7-a5', 'b7-b6', 'b7-b5', 'c7-c6', 'c7-c5',
            'd5-e4', 'e7-e6', 'e7-e5', 'f7-f6', 'f7-f5',
            'g7-g6', 'g7-g5', 'h7-h6', 'h7-h5',
            'b8-a6', 'b8-c6', 'b8-d7', 'g8-f6', 'g8-h6'
          ]
        },
        other_player_legal_moves: [
          'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
          'e4-e5', 'e4-d5', 'f2-f3', 'f2-f4', 'g2-g3', 'g2-g4',
          'h2-h3', 'h2-h4', 'b1-a3', 'b1-c3', 'b1-d2',
          'g1-e2', 'g1-f3', 'g1-h3'
        ]
      },
      'black pawn captures' => {
        state_before: {
          board: 'rnbqkbnr' +
                 'ppp..ppp' +
                 '........' +
                 '...pp...' +
                 '...P....' +
                 '........' +
                 'PPP.PPPP' +
                 'RNBQKBNR',
          history: ['d2-d4', 'd7-d5', 'e2-e4'],
          next_to_move: 1,
          legal_moves: [
            'a7-a6', 'a7-a5', 'b7-b6', 'b7-b5', 'c7-c6', 'c7-c5',
            'd5-e4', 'e7-e6', 'e7-e5', 'f7-f6', 'f7-f5',
            'g7-g6', 'g7-g5', 'h7-h6', 'h7-h5',
            'b8-a6', 'b8-c6', 'b8-d7', 'g8-f6', 'g8-h6'
          ]
        },
        move: 'd5-e4',
        state_after: {
          board: 'rnbqkbnr' +
                 'ppp..ppp' +
                 '........' +
                 '...pP...' +
                 '........' +
                 '........' +
                 'PPP.PPPP' +
                 'RNBQKBNR',
          history: ['d4', 'd5', 'e4', 'd5-e4'],
          next_to_move: 0,
          legal_moves: [
            'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
            'd4-d5', 'f2-f3', 'f2-f4', 'g2-g3', 'g2-g4',
            'h2-h3', 'h2-h4', 'b1-a3', 'b1-c3', 'b1-d2',
            'g1-e2', 'g1-f3', 'g1-h3'
          ]
        },
        other_player_legal_moves: [
          'a7-a6', 'a7-a5', 'b7-b6', 'b7-b5', 'c7-c6', 'c7-c5',
          'e7-e6', 'e7-e5', 'e4-e3', 'f7-f6', 'f7-f5',
          'g7-g6', 'g7-g5', 'h7-h6', 'h7-h5',
          'b8-a6', 'b8-c6', 'b8-d7', 'g8-f6', 'g8-h6'
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
