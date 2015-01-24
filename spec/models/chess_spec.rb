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
    shared_examples "move examples" do
      subject {
        FactoryGirl.create(:chess, :started)
      }

      before do
        subject.update_attributes(state: state_before)
        subject.execute_move(move)
      end

      it 'has the correct board' do
        expect(subject.state['board']).to eq state_after[:board]
      end

      it 'includes the move in the history' do
        expect(subject.state['history'].last).to eq move
      end

      it 'has the correct next to move' do
        expect(subject.state['next_to_move']).to eq state_after[:next_to_move]
      end

      it 'has the correct legal moves for the other player' do
        subject.state['legal_moves'].each do |move|
          expect(state_after[:legal_moves]).to include(move)
        end

        state_after[:legal_moves].each do |move|
          expect(subject.state['legal_moves']).to include(move)
        end
      end

      it 'has the correct moves for the current player`' do
        current_player_legal_moves = subject.legal_moves(
          subject.state['board'], (subject.state['next_to_move'] + 1) % 2)

        current_player_legal_moves.each do |move|
          expect(other_player_legal_moves).to include(move)
        end

        other_player_legal_moves.each do |move|
          expect(current_player_legal_moves).to include(move)
        end
      end

      it 'has the correct check state' do
        expect(subject.state['check']).to eq state_after[:check]
      end
    end

    context "pawn" do
      context "white moves one space" do
        include_examples "move examples"
        let(:state_before) {
          { board: initial_board,
            history: [],
            next_to_move: 0,
            legal_moves: [
              'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
              'd2-d3', 'd2-d4', 'e2-e3', 'e2-e4', 'f2-f3', 'f2-f4',
              'g2-g3', 'g2-g4', 'h2-h3', 'h2-h4', 'b2-a3', 'b2-c3',
              'g2-f3', 'g2-h3'
            ]
          }
        }
        let(:move) {'d2-d3'}
        let(:state_after) {
          { board: 'rnbqkbnr' +
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
            ],
            check: false
          }
        }
        let(:other_player_legal_moves) {
          [ 'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
            'd3-d4', 'e2-e3', 'e2-e4', 'f2-f3', 'f2-f4',
            'g2-g3', 'g2-g4', 'h2-h3', 'h2-h4', 'b1-a3', 'b1-c3', 'b1-d2',
            'g1-f3', 'g1-h3', 'd1-d2', 'e1-d2',
            'c1-d2', 'c1-e3', 'c1-f4', 'c1-g5', 'c1-h6'
          ]
        }
      end
    end

    Hash[
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
          ],
          check: false
        },
        other_player_legal_moves: [
          'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
          'd4-d5', 'e2-e3', 'e2-e4', 'f2-f3', 'f2-f4',
          'g2-g3', 'g2-g4', 'h2-h3', 'h2-h4', 'b1-a3', 'b1-c3', 'b1-d2',
          'g1-f3', 'g1-h3', 'd1-d2', 'd1-d3', 'e1-d2',
          'c1-d2', 'c1-e3', 'c1-f4', 'c1-g5', 'c1-h6'
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
            'g1-f3', 'g1-h3', 'd1-d2', 'd1-d3', 'e1-d2',
            'c1-d2', 'c1-e3', 'c1-f4', 'c1-g5', 'c1-h6'
          ],
          check: false
        },
        other_player_legal_moves: [
          'a7-a6', 'a7-a5', 'b7-b6', 'b7-b5', 'c7-c6', 'c7-c5',
          'd6-d5', 'e7-e6', 'e7-e5', 'f7-f6', 'f7-f5',
          'g7-g6', 'g7-g5', 'h7-h6', 'h7-h5', 'b8-a6', 'b8-c6', 'b8-d7',
          'g8-f6', 'g8-h6', 'c8-d7', 'c8-e6', 'c8-f5', 'c8-g4', 'c8-h3',
          'd8-d7', 'e8-d7'
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
            'e2-e3', 'e2-e4', 'f2-f3', 'f2-f4',
            'g2-g3', 'g2-g4', 'h2-h3', 'h2-h4', 'b1-a3', 'b1-c3', 'b1-d2',
            'g1-f3', 'g1-h3', 'd1-d2', 'd1-d3', 'e1-d2',
            'c1-d2', 'c1-e3', 'c1-f4', 'c1-g5', 'c1-h6'
          ],
          check: false
        },
        other_player_legal_moves: [
          'a7-a6', 'a7-a5', 'b7-b6', 'b7-b5', 'c7-c6', 'c7-c5',
          'e7-e6', 'e7-e5', 'f7-f6', 'f7-f5', 'g7-g6', 'g7-g5',
          'h7-h6', 'h7-h5', 'b8-a6', 'b8-c6', 'b8-d7',
          'g8-f6', 'g8-h6', 'e8-d7', 'c8-d7', 'c8-e6', 'c8-f5',
          'c8-g4', 'c8-h3', 'd8-d7', 'd8-d6'
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
            'g1-f3', 'g1-h3', 'e1-d2'
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
            'd5-e4', 'e7-e6', 'e7-e5', 'f7-f6', 'f7-f5', 'g7-g6', 'g7-g5',
            'h7-h6', 'h7-h5', 'b8-a6', 'b8-c6', 'b8-d7',
            'g8-f6', 'g8-h6', 'e8-d7', 'c8-d7', 'c8-e6', 'c8-f5',
            'c8-g4', 'c8-h3', 'd8-d7', 'd8-d6'
          ],
          check: false
        },
        other_player_legal_moves: [
          'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
          'e4-e5', 'e4-d5', 'f2-f3', 'f2-f4', 'g2-g3', 'g2-g4',
          'h2-h3', 'h2-h4', 'b1-a3', 'b1-c3', 'b1-d2',
          'g1-e2', 'g1-f3', 'g1-h3', 'e1-d2', 'e1-e2',
          'c1-d2', 'c1-e3', 'c1-f4', 'c1-g5', 'c1-h6',
          'd1-d2', 'd1-d3', 'd1-e2', 'd1-f3', 'd1-g4', 'd1-h5',
          'f1-e2', 'f1-d3', 'f1-c4', 'f1-b5', 'f1-a6'
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
            'g1-e2', 'g1-f3', 'g1-h3', 'e1-d2', 'e1-e2',
            'c1-d2', 'c1-e3', 'c1-f4', 'c1-g5', 'c1-h6',
            'd1-d2', 'd1-d3', 'd1-e2', 'd1-f3', 'd1-g4', 'd1-h5',
            'f1-e2', 'f1-d3', 'f1-c4', 'f1-b5', 'f1-a6'
          ],
          check: false
        },
        other_player_legal_moves: [
          'a7-a6', 'a7-a5', 'b7-b6', 'b7-b5', 'c7-c6', 'c7-c5',
          'e7-e6', 'e7-e5', 'e4-e3', 'f7-f6', 'f7-f5',
          'g7-g6', 'g7-g5', 'h7-h6', 'h7-h5',
          'b8-a6', 'b8-c6', 'b8-d7', 'g8-f6', 'g8-h6', 'e8-d7',
          'c8-d7', 'c8-e6', 'c8-f5',
          'c8-g4', 'c8-h3', 'd8-d7', 'd8-d6', 'd8-d5', 'd8-d4'
        ]
      },
      'white pawn promotion to knight' => {
        state_before: {
          board: '....k...' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '.......K' +
                 '....p...' +
                 '........',
          history: [],
          next_to_move: 0,
          legal_moves: [
            'e1-d1', 'e1-f1', 'e1-d2', 'e1-e2', 'e1-f2',
            'e7-e8-q', 'e7-e8-r', 'e7-e8-n', 'e7-e8-b'
          ]
        },
        move: 'e7-e8-n',
        state_after: {
          board: '....k...' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '.......K' +
                 '........' +
                 '....n...',
          history: ['e7-e8-n'],
          next_to_move: 1,
          legal_moves: [
            'h6-h5', 'h6-h7', 'h6-g5', 'h6-g6', 'h6-g7', 'h6-h7'
          ],
          check: false
        },
        other_player_legal_moves: [
          'e1-d1', 'e1-f1', 'e1-d2', 'e1-e2', 'e1-f2',
          'e8-c7', 'e8-d6', 'e8-f6', 'e8-g7'
        ]
      },
      'rook moves' => {
        state_before: {
          board: '.r..k...' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '.......K' +
                 '........' +
                 '........',
          history: [],
          next_to_move: 0,
          legal_moves: [
            'e1-d1', 'e1-f1', 'e1-d2', 'e1-e2', 'e1-f2',
            'b1-b2', 'b1-b3', 'b1-b4', 'b1-b5', 'b1-b6', 'b1-b7', 'b1-b8',
            'b1-a1', 'b1-a3', 'b1-a4',
          ]
        },
        move: 'b1-b4',
        state_after: {
          board: '....k...' +
                 '........' +
                 '........' +
                 '.r......' +
                 '........' +
                 '.......K' +
                 '........' +
                 '........',
          history: ['b1-b4'],
          next_to_move: 1,
          legal_moves: [
            'h6-h5', 'h6-h7', 'h6-g5', 'h6-g6', 'h6-g7', 'h6-h7'
          ],
          check: false
        },
        other_player_legal_moves: [
          'e1-d1', 'e1-f1', 'e1-d2', 'e1-e2', 'e1-f2',
          'b4-b1', 'b4-b2', 'b4-b3', 'b4-b5', 'b4-b6', 'b4-b7', 'b4-b8',
          'b4-a4', 'b4-c4', 'b4-d4', 'b4-e4', 'b4-f4', 'b4-g4', 'b4-h4'
        ]
      },
      'bishop moves' => {
        state_before: {
          board: '..b.k...' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '......K.',
          history: [],
          next_to_move: 0,
          legal_moves: [
            'e1-d1', 'e1-f1', 'e1-d1', 'e1-d2', 'e1-e2', 'e1-f2',
            'c1-d2', 'c1-e3', 'c1-f4', 'c1-g5', 'c1-h6',
            'c1-b2', 'c1-a3'
          ]
        },
        move: 'c1-e3',
        state_after: {
          board: '....k...' +
                 '........' +
                 '....b...' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '......K.',
          history: ['c1-e3'],
          next_to_move: 1,
          legal_moves: [
            'g8-f8', 'g8-f7', 'g8-g7', 'g8-h7', 'g8-h8'
          ],
          check: false
        },
        other_player_legal_moves: [
          'e1-d1', 'e1-d2', 'e1-e2', 'e1-f2', 'e1-f1',
          'e3-c1', 'e3-d2', 'e3-f4', 'e3-g5', 'e3-h6',
          'e3-g1', 'e3-f2', 'e3-d4', 'e3-c5', 'e3-b6', 'e3-a7'
        ]
      },
      'queen moves' => {
        state_before: {
          board: '.q..k...' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '.......K' +
                 '........' +
                 '........',
          history: [],
          next_to_move: 0,
          legal_moves: [
            'e1-d1', 'e1-f1', 'e1-d2', 'e1-e2', 'e1-f2',
            'b1-b2', 'b1-b3', 'b1-b4', 'b1-b5', 'b1-b6', 'b1-b7', 'b1-b8',
            'b1-a1', 'b1-a3', 'b1-a4', 'b1-c2', 'b1-d3', 'b1-e4', 'b1-f5',
            'b1-g6', 'b1-h7', 'b1-a2'
          ]
        },
        move: 'b1-b4',
        state_after: {
          board: '....k...' +
                 '........' +
                 '........' +
                 '.q......' +
                 '........' +
                 '.......K' +
                 '........' +
                 '........',
          history: ['b1-b4'],
          next_to_move: 1,
          legal_moves: [
            'h6-h5', 'h6-h7', 'h6-g5', 'h6-g6', 'h6-g7', 'h6-h7'
          ],
          check: false
        },
        other_player_legal_moves: [
          'e1-d1', 'e1-f1', 'e1-d2', 'e1-e2', 'e1-f2',
          'b4-b1', 'b4-b2', 'b4-b3', 'b4-b5', 'b4-b6', 'b4-b7', 'b4-b8',
          'b4-a4', 'b4-c4', 'b4-d4', 'b4-e4', 'b4-f4', 'b4-g4', 'b4-h4',
          'b4-a3', 'b4-c5', 'b4-d6', 'b4-e7', 'b4-f8',
          'b4-a5', 'b4-c3', 'b4-d2'
        ]
      },
      'pinned piece' => {
        state_before: {
          board: '...k....' +
                 '...n....' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '......R.' +
                 '......K.',
          history: [],
          next_to_move: 1,
          legal_moves: [
            'g8-h8', 'g8-h7', 'g8-f7', 'g8-f8',
            'g7-a7', 'g7-b7', 'g7-c7', 'g7-d7', 'g7-e7', 'g7-f7', 'g7-h7',
            'g7-g6', 'g7-g5', 'g7-g4', 'g7-g3', 'g7-g2', 'g7-g1'
          ]
        },
        move: 'g7-d7',
        state_after: {
          board: '...k....' +
                 '...n....' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '...R....' +
                 '......K.',
          history: ['g7-d7'],
          next_to_move: 0,
          legal_moves: [
            'd1-c1', 'd1-c2', 'd1-e2', 'd1-e1'
          ],
          check: false
        },
        other_player_legal_moves: [
          'g8-h8', 'g8-h7', 'g8-g7', 'g8-f7', 'g8-f8',
          'd7-a7', 'd7-b7', 'd7-c7', 'd7-e7', 'd7-f7', 'd7-g7', 'd7-h7',
          'd7-d8', 'd7-d6', 'd7-d5', 'd7-d4', 'd7-d3', 'd7-d2'
        ]
      },
      'check' => {
        state_before: {
          board: '...k....' +
                 '...n....' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '.....R..' +
                 '......K.',
          history: [],
          next_to_move: 1,
          legal_moves: [
            'g8-h8', 'g8-h7', 'g8-f7', 'g8-f8',
            'f7-a7', 'f7-b7', 'f7-c7', 'f7-d7', 'f7-e7', 'f7-g7', 'f7-h7',
            'f7-f6', 'f7-f5', 'f7-f4', 'f7-f3', 'f7-f2', 'f7-f1'
          ]
        },
        move: 'f7-f1',
        state_after: {
          board: '...k.R..' +
                 '...n....' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '......K.',
          history: ['f7-f1'],
          next_to_move: 0,
          legal_moves: ['d2-f1'],
          check: true
        },
        other_player_legal_moves: [
          'g8-h8', 'g8-h7', 'g8-g7', 'g8-f7', 'g8-f8',
          'f1-d1', 'f1-e1', 'f1-g1', 'f1-h1',
          'f1-f2', 'f1-f3', 'f1-f4', 'f1-f5', 'f1-f6', 'f1-f7', 'f1-f8'
        ]
      },
      'checkmate' => {
        state_before: {
          board: '...k....' +
                 '...n....' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '......R.' +
                 '......K.',
          history: [],
          next_to_move: 1,
          legal_moves: [
            'g8-h8', 'g8-h7', 'g8-f7', 'g8-f8',
            'g7-a7', 'g7-b7', 'g7-c7', 'g7-d7', 'g7-e7', 'g7-f7', 'g7-h7',
            'g7-g6', 'g7-g5', 'g7-g4', 'g7-g3', 'g7-g2', 'g7-g1'
          ]
        },
        move: 'g7-g1',
        state_after: {
          board: '...k..R.' +
                 '...n....' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '........' +
                 '......K.',
          history: ['g7-g1'],
          next_to_move: 0,
          legal_moves: [],
          check: true
        },
        other_player_legal_moves: [
          'g8-h8', 'g8-h7', 'g8-g7', 'g8-f7', 'g8-f8',
          'g1-d1', 'g1-e1', 'g1-f1', 'g1-h1',
          'g1-g2', 'g1-g3', 'g1-g4', 'g1-g5', 'g1-g6', 'g1-g7'
        ]
      }
    ].each do |name, test|
      context name do
        
      end
    end
  end
end
