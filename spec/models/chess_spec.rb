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
          subject.state['board'], (subject.state['next_to_move'] + 1) % 2, true)

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

    shared_examples "legal move examples" do
      subject {
        FactoryGirl.create(:chess, :started)
      }

      before do
        subject.state['history'] = history
        subject.state['board'] = board
        subject.state['next_to_move'] = next_to_move
        subject.save
      end

      it 'has the correct legal moves for the current player' do
        subject.legal_moves(board, next_to_move, true).each do |move|
          expect(legal_moves).to include(move)
        end

        legal_moves.each do |move|
          expect(subject.legal_moves(board, next_to_move, true)).to include(move)
        end
      end

      it 'has the correct legal moves for the other player' do
        subject.legal_moves(board, (next_to_move + 1) % 2, true).each do |move|
          expect(other_player_legal_moves).to include(move)
        end

        other_player_legal_moves.each do |move|
          expect(subject.legal_moves(board, (next_to_move + 1) % 2, true)).to include(move)
        end
      end

      it 'has the correct check state' do
        expect(subject.state['check']).to eq state_after[:check]
      end
    end

    context 'illegal move' do
      subject {
        FactoryGirl.create(:chess, :started)
      }

      it 'throws an exception' do
        subject.update_attributes(state: {
          board: initial_board,
          history: [],
          next_to_move: 0,
          legal_moves: [
            'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
            'd2-d3', 'd2-d4', 'e2-e3', 'e2-e4', 'f2-f3', 'f2-f4',
            'g2-g3', 'g2-g4', 'h2-h3', 'h2-h4', 'b2-a3', 'b2-c3',
            'g2-f3', 'g2-h3'
          ]
        })
        expect { subject.execute_move('') }.to raise_error(IllegalMove)
      end
    end

    context 'piece movement' do
      context 'pawn' do
        context "white" do
          context "from initial position" do
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

            context "moves one space" do
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
              include_examples "move examples"
            end

            context "moves two spaces" do
              let(:move) {'d2-d4'}
              let(:state_after) {
                { board: 'rnbqkbnr' +
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
                }
              }
              let(:other_player_legal_moves) {
                [ 'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
                  'd4-d5', 'e2-e3', 'e2-e4', 'f2-f3', 'f2-f4',
                  'g2-g3', 'g2-g4', 'h2-h3', 'h2-h4', 'b1-a3', 'b1-c3', 'b1-d2',
                  'g1-f3', 'g1-h3', 'd1-d2', 'd1-d3', 'e1-d2',
                  'c1-d2', 'c1-e3', 'c1-f4', 'c1-g5', 'c1-h6'
                ]
              }
              include_examples "move examples"
            end
          end

          context "threatens capture" do
            let(:state_before) {
              { board: 'rnbqkbnr' +
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
            } }
            let(:move) { 'e2-e4' }
            let(:state_after) {
              { board: 'rnbqkbnr' +
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
            } }
            let(:other_player_legal_moves) { [
              'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
              'e4-e5', 'e4-d5', 'f2-f3', 'f2-f4', 'g2-g3', 'g2-g4',
              'h2-h3', 'h2-h4', 'b1-a3', 'b1-c3', 'b1-d2',
              'g1-e2', 'g1-f3', 'g1-h3', 'e1-d2', 'e1-e2',
              'c1-d2', 'c1-e3', 'c1-f4', 'c1-g5', 'c1-h6',
              'd1-d2', 'd1-d3', 'd1-e2', 'd1-f3', 'd1-g4', 'd1-h5',
              'f1-e2', 'f1-d3', 'f1-c4', 'f1-b5', 'f1-a6'
            ] }

            include_examples "move examples"
          end

          context "promotion" do
            context "to knight" do
              let(:state_before) {
                { board: '....k...' +
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
                } }
              let(:move) { 'e7-e8-n' }
              let(:state_after) {
                { board: '....k...' +
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
                    'h6-h5', 'h6-h7', 'h6-g5', 'h6-g6', 'h6-h7'
                  ],
                  check: false
                } }
              let(:other_player_legal_moves) { [
                'e1-d1', 'e1-f1', 'e1-d2', 'e1-e2', 'e1-f2',
                'e8-c7', 'e8-d6', 'e8-f6', 'e8-g7'
              ] }

              include_examples "move examples"
            end

            context "to queen" do
              let(:state_before) {
                { board: '....k...' +
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
                } }
              let(:move) { 'e7-e8-q' }
              let(:state_after) {
                { board: '....k...' +
                         '........' +
                         '........' +
                         '........' +
                         '........' +
                         '.......K' +
                         '........' +
                         '....q...',
                  history: ['e7-e8-q'],
                  next_to_move: 1,
                  legal_moves: [
                    'h6-g5', 'h6-g7', 'h6-h7'
                  ],
                  check: false
                } }
              let(:other_player_legal_moves) { [
                'e1-d1', 'e1-f1', 'e1-d2', 'e1-e2', 'e1-f2',
                'e8-a8', 'e8-b8', 'e8-c8', 'e8-d8', 'e8-f8', 'e8-g8', 'e8-h8',
                'e8-e2', 'e8-e3', 'e8-e4', 'e8-e5', 'e8-e6', 'e8-e7',
                'e8-d7', 'e8-c6', 'e8-b5', 'e8-a4',
                'e8-f7', 'e8-g6', 'e8-h5'
              ] }

              include_examples "move examples"
            end
          end
        end

        context "black" do
          context "from initial position" do
            let(:state_before) {
              {
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
              }
            }

            context "moves one space" do
              let(:move) { 'd7-d6' }
              let(:state_after) {
                { board: 'rnbqkbnr' +
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
                }
              }
              let(:other_player_legal_moves) {
                [ 'a7-a6', 'a7-a5', 'b7-b6', 'b7-b5', 'c7-c6', 'c7-c5',
                  'd6-d5', 'e7-e6', 'e7-e5', 'f7-f6', 'f7-f5',
                  'g7-g6', 'g7-g5', 'h7-h6', 'h7-h5', 'b8-a6', 'b8-c6', 'b8-d7',
                  'g8-f6', 'g8-h6', 'c8-d7', 'c8-e6', 'c8-f5', 'c8-g4', 'c8-h3',
                  'd8-d7', 'e8-d7'
                ]
              }
              include_examples "move examples"
            end

            context "moves two spaces" do
              let(:move) { 'd7-d5' }
              let(:state_after) {
                { board: 'rnbqkbnr' +
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
                }
              }
              let(:other_player_legal_moves) {
                [ 'a7-a6', 'a7-a5', 'b7-b6', 'b7-b5', 'c7-c6', 'c7-c5',
                  'e7-e6', 'e7-e5', 'f7-f6', 'f7-f5', 'g7-g6', 'g7-g5',
                  'h7-h6', 'h7-h5', 'b8-a6', 'b8-c6', 'b8-d7',
                  'g8-f6', 'g8-h6', 'e8-d7', 'c8-d7', 'c8-e6', 'c8-f5',
                  'c8-g4', 'c8-h3', 'd8-d7', 'd8-d6'
                ]
              }
              include_examples "move examples"
            end

            context "captures" do
              let(:state_before) {
                { board: 'rnbqkbnr' +
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
                } }
              let(:move) { 'd5-e4' }
              let(:state_after) {
                { board: 'rnbqkbnr' +
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
                } }
              let(:other_player_legal_moves) { [
                'a7-a6', 'a7-a5', 'b7-b6', 'b7-b5', 'c7-c6', 'c7-c5',
                'e7-e6', 'e7-e5', 'e4-e3', 'f7-f6', 'f7-f5',
                'g7-g6', 'g7-g5', 'h7-h6', 'h7-h5',
                'b8-a6', 'b8-c6', 'b8-d7', 'g8-f6', 'g8-h6', 'e8-d7',
                'c8-d7', 'c8-e6', 'c8-f5',
                'c8-g4', 'c8-h3', 'd8-d7', 'd8-d6', 'd8-d5', 'd8-d4'
              ] }

              include_examples "move examples"
            end
          end
        end
      end

      context 'rook' do
        let(:state_before) {
          { board: '.r..k...' +
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
          } }
        let(:move) { 'b1-b4' }
        let(:state_after) {
          { board: '....k...' +
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
          } }
        let(:other_player_legal_moves) { [
            'e1-d1', 'e1-f1', 'e1-d2', 'e1-e2', 'e1-f2',
            'b4-b1', 'b4-b2', 'b4-b3', 'b4-b5', 'b4-b6', 'b4-b7', 'b4-b8',
            'b4-a4', 'b4-c4', 'b4-d4', 'b4-e4', 'b4-f4', 'b4-g4', 'b4-h4'
          ] }

        include_examples "move examples"
      end

      context 'bishop' do
        let(:state_before) {
          { board: '..b.k...' +
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
          } }
        let(:move) { 'c1-e3' }
        let(:state_after) {
          { board: '....k...' +
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
          } }
        let(:other_player_legal_moves) { [
            'e1-d1', 'e1-d2', 'e1-e2', 'e1-f2', 'e1-f1',
            'e3-c1', 'e3-d2', 'e3-f4', 'e3-g5', 'e3-h6',
            'e3-g1', 'e3-f2', 'e3-d4', 'e3-c5', 'e3-b6', 'e3-a7'
          ] }

        include_examples "move examples"
      end

      context 'queen' do
        let(:state_before) {
          { board: '.q..k...' +
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
          } }
        let(:move) { 'b1-b4' }
        let(:state_after) {
          { board: '....k...' +
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
          } }
        let(:other_player_legal_moves) { [
            'e1-d1', 'e1-f1', 'e1-d2', 'e1-e2', 'e1-f2',
            'b4-b1', 'b4-b2', 'b4-b3', 'b4-b5', 'b4-b6', 'b4-b7', 'b4-b8',
            'b4-a4', 'b4-c4', 'b4-d4', 'b4-e4', 'b4-f4', 'b4-g4', 'b4-h4',
            'b4-a3', 'b4-c5', 'b4-d6', 'b4-e7', 'b4-f8',
            'b4-a5', 'b4-c3', 'b4-d2'
          ] }

        include_examples "move examples"
      end
    end

    context 'king' do
      let(:state_before) {
        { board: '.q..k...' +
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
        } }
      let(:move) { 'e1-e2' }
      let(:state_after) {
        { board: '.q......' +
                 '....k...' +
                 '........' +
                 '........' +
                 '........' +
                 '.......K' +
                 '........' +
                 '........',
          history: ['b1-b4'],
          next_to_move: 1,
          legal_moves: [
            'h6-h5', 'h6-g5', 'h6-g7'
          ],
          check: false
        } }
      let(:other_player_legal_moves) { [
          'e2-d1', 'e2-e1', 'e2-f1', 'e2-d2', 'e2-f2', 'e2-d3', 'e2-e3', 'e2-f3',
          'b1-a1', 'b1-c1', 'b1-d1', 'b1-e1', 'b1-f1', 'b1-g1', 'b1-h1',
          'b1-b2', 'b1-b3', 'b1-b4', 'b1-b5', 'b1-b6', 'b1-b7', 'b1-b8',
          'b1-a2', 'b1-c2', 'b1-d3', 'b1-e4', 'b1-f5', 'b1-g6', 'b1-h7'
        ] }

      include_examples "move examples"

      context "castling" do
        context 'white' do
          let(:next_to_move) { 0 }
          context 'king-side' do
            context 'legal castle' do
              let(:state_before) {
                { board: '....k..r' +
                         '........' +
                         '........' +
                         '........' +
                         '........' +
                         '........' +
                         '........' +
                         '...QK...',
                  history: [],
                  next_to_move: 0,
                  legal_moves: [
                    'e1-d1', 'e1-g1', 'e1-d2', 'e1-e2', 'e1-e3', 'o-o',
                    'h1-g1', 'h1-f1', 'h1-h2', 'h1-h3', 'h1-h4', 'h1-h5',
                    'h1-h6', 'h1-h7', 'h1-h8'
                  ]
                } }
              let(:move) { 'o-o' }
              let(:state_after) {
                { board: '.....rk.' +
                         '........' +
                         '........' +
                         '........' +
                         '........' +
                         '........' +
                         '........' +
                         '...QK...',
                  history: ['o-o'],
                  next_to_move: 1,
                  legal_moves: [
                    'e8-e7', 'e8-d7', 'd8-a8', 'd8-b8', 'd8-c8', 'd8-d7', 'd8-d6',
                    'd8-d5', 'd8-d4', 'd8-d3', 'd8-d2', 'd8-d1', 'd8-c7', 'd8-b6',
                    'd8-a5', 'd8-e7', 'd8-f6', 'd8-g5', 'd8-h4'
                  ],
                  check: false
                } }
              let(:other_player_legal_moves) { [
                  'g1-h1', 'g1-f2', 'g1-g2', 'g1-h2', 'f1-a1', 'f1-b1', 'f1-c1',
                  'f1-d1', 'f1-e1', 'f1-f2', 'f1-f3', 'f1-f4', 'f1-f5', 'f1-f6',
                  'f1-f7', 'f1-f8'
                ] }

              include_examples "move examples"
            end

            context 'castle with a piece in the way' do
              let(:board) {
                '....k.nr' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '.....K.R' }
              let(:history) { [] }

              let(:other_player_legal_moves) {[
                'f8-e8', 'f8-e7', 'f8-f7', 'f8-g7', 'f8-g8',
                'h8-g8', 'h8-h7', 'h8-h6', 'h8-h5', 'h8-h4',
                'h8-h3', 'h8-h2', 'h8-h1'
              ]}
              let(:legal_moves) { [
                'e1-d1', 'e1-d2', 'e1-e2', 'e1-f2', 'e1-f1',
                'g1-e2', 'g1-f3', 'g1-h3', 'h1-h2', 'h1-h3',
                'h1-h4', 'h1-h5', 'h1-h6', 'h1-h7', 'h1-h8'
              ]}

              let (:check) { false }

              include_examples "legal move examples"
            end

            context 'castle out of check' do
              let(:board) {
                '....k..r' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '....RK..' }
              let(:history) { [] }

              let(:other_player_legal_moves) {[
                'e8-d8', 'e8-c8', 'e8-b8', 'e8-a8', 'e8-e7', 'e8-e6',
                'e8-e5', 'e8-e4', 'e8-e3', 'e8-e2', 'e8-e1', 'f8-e7',
                'f8-f7', 'f8-g7', 'f8-g8' ]}
              let(:legal_moves) {[
                'e1-d1', 'e1-d2', 'e1-f1', 'e1-f2' ]}

              let (:check) { true }

              include_examples "legal move examples"
            end

            context 'castle through check' do
              let(:board) {
                '....k..r' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '....KR..' }
              let(:history) { [] }

              let(:other_player_legal_moves) {[
                'e8-d8', 'e8-d7', 'e8-e7', 'e8-f7', 'f8-g8', 'f8-h8',
                'f8-f7', 'f8-f6', 'f8-f5', 'f8-f4', 'f8-f3', 'f8-f2',
                'f8-f1'
              ]}
              let(:legal_moves) {[
                'e1-d1', 'e1-d2', 'e1-e2', 'h1-g1', 'h1-f1', 'h1-h2',
                'h1-h3', 'h1-h4', 'h1-h5', 'h1-h6', 'h1-h7', 'h1-h8'
              ]}

              let (:check) { false }

              include_examples "legal move examples"
            end

            context 'castle when the king has moved' do
              let(:board) {
                '....k..r' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '.....K.R' }
              let(:history) { ['e1-e2', 'e8-f8', 'e2-e1'] }
                  
              let(:other_player_legal_moves) {[
                'f8-e8', 'f8-e7', 'f8-f7', 'f8-g7', 'f8-g8',
                'h8-g8', 'h8-h7', 'h8-h6', 'h8-h5', 'h8-h4',
                'h8-h3', 'h8-h2', 'h8-h1'
              ]}
              let(:legal_moves) { [
                'e1-d1', 'e1-d2', 'e1-e2', 'e1-f2', 'e1-f1',
                'h1-g1', 'h1-f1', 'h1-h2', 'h1-h3', 'h1-h4',
                'h1-h5', 'h1-h6', 'h1-h7', 'h1-h8'
              ]}

              let (:check) { false }

              include_examples "legal move examples"
            end

            context 'castle when the rook has moved' do
              let(:board) {
                '....k..r' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '.....K.R' }
              let(:history) { ['h1-h2', 'e8-f8', 'h2-h1'] }

              let(:other_player_legal_moves) {[
                'f8-e8', 'f8-e7', 'f8-f7', 'f8-g7', 'f8-g8',
                'h8-g8', 'h8-h7', 'h8-h6', 'h8-h5', 'h8-h4',
                'h8-h3', 'h8-h2', 'h8-h1'
              ]}
              let(:legal_moves) { [
                'e1-d1', 'e1-d2', 'e1-e2', 'e1-f2', 'e1-f1',
                'h1-g1', 'h1-f1', 'h1-h2', 'h1-h3', 'h1-h4',
                'h1-h5', 'h1-h6', 'h1-h7', 'h1-h8'
              ]}

              let (:check) { false }

              include_examples "legal move examples"
            end
          end

          context 'queen-side' do
            context 'legal castle' do
              let(:state_before) {
                { board: 'r...k...' +
                         '........' +
                         '........' +
                         '........' +
                         '........' +
                         '........' +
                         '........' +
                         '....K..R',
                  history: [],
                  next_to_move: 0,
                  legal_moves: [
                    'e1-d1', 'e1-g1', 'e1-d2', 'e1-e2', 'e1-e3', 'o-o-o',
                    'a1-b1', 'a1-c1', 'a1-d1', 'a1-b1', 'a1-c1', 'a1-d1',
                    'a1-e1', 'a1-f1', 'a1-g1'
                  ]
                } }
              let(:move) { 'o-o-o' }
              let(:state_after) {
                { board: '..kr....' +
                         '........' +
                         '........' +
                         '........' +
                         '........' +
                         '........' +
                         '........' +
                         '....K..R',
                  history: ['o-o-o'],
                  next_to_move: 1,
                  legal_moves: [
                    'e8-e7', 'e8-f7', 'e8-f8', 'h8-f8', 'h8-g8', 'h8-h7',
                    'h8-h6', 'h8-h5', 'h8-h4', 'h8-h3', 'h8-h2', 'h8-h1'
                  ],
                  check: false
                } }
              let(:other_player_legal_moves) { [
                  'c1-b1', 'c1-b2', 'c1-c2', 'c1-d2', 'd1-e1', 'd1-f1',
                  'd1-g1', 'd1-h1', 'd1-d2', 'd1-d3', 'd1-d4', 'd1-d5',
                  'd1-d6', 'd1-d7', 'd1-d8'
                ] }

              include_examples "move examples"
            end

            context 'castle with a piece in the way' do
              let(:board) {
                'rn..k...' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '.....K.R' }
              let(:history) { [] }

              let(:other_player_legal_moves) {[
                'f8-e8', 'f8-e7', 'f8-f7', 'f8-g7', 'f8-g8',
                'h8-g8', 'h8-h7', 'h8-h6', 'h8-h5', 'h8-h4',
                'h8-h3', 'h8-h2', 'h8-h1'
              ]}
              let(:legal_moves) { [
                'e1-d1', 'e1-d2', 'e1-e2', 'e1-f2', 'e1-f1',
                'b1-a3', 'b1-d2', 'b1-c3', 'a1-a2', 'a1-a3',
                'a1-a4', 'a1-a5', 'a1-a6', 'a1-a7', 'a1-a8'
              ]}

              let (:check) { false }

              include_examples "legal move examples"
            end

            context 'castle out of check' do
              let(:board) {
                'r...k...' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '....RK..' }
              let(:history) { [] }

              let(:other_player_legal_moves) {[
                'e8-d8', 'e8-c8', 'e8-b8', 'e8-a8', 'e8-e7', 'e8-e6',
                'e8-e5', 'e8-e4', 'e8-e3', 'e8-e2', 'e8-e1', 'f8-e7',
                'f8-f7', 'f8-g7', 'f8-g8' ]}
              let(:legal_moves) {[
                'e1-d1', 'e1-d2', 'e1-f1', 'e1-f2' ]}

              let (:check) { true }

              include_examples "legal move examples"
            end

            context 'castle through check' do
              let(:board) {
                'r...k...' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '...RK...' }
              let(:history) { [] }

              let(:other_player_legal_moves) {[
                'd8-c8', 'd8-b8', 'd8-a8', 'd8-d7', 'd8-d6', 'd8-d5',
                'd8-d4', 'd8-d3', 'd8-d2', 'd8-d1', 'e8-d7', 'e8-e7',
                'e8-f7', 'e8-f8'
              ]}
              let(:legal_moves) {[
                'e1-e2', 'e1-f1', 'e1-f2', 'a1-b1', 'a1-c1', 'a1-d1',
                'a1-a2', 'a1-a3', 'a1-a4', 'a1-a5', 'a1-a6', 'a1-a7',
                'a1-a8'
              ]}

              let (:check) { false }

              include_examples "legal move examples"
            end

            context 'castle when the king has moved' do
              let(:board) {
                'r...k...' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '.....K.R' }
              let(:history) { ['e1-e2', 'e8-f8', 'e2-e1'] }

              let(:other_player_legal_moves) {[
                'f8-e8', 'f8-e7', 'f8-f7', 'f8-g7', 'f8-g8',
                'h8-g8', 'h8-h7', 'h8-h6', 'h8-h5', 'h8-h4',
                'h8-h3', 'h8-h2', 'h8-h1'
              ]}
              let(:legal_moves) { [
                'e1-d1', 'e1-d2', 'e1-e2', 'e1-f2', 'e1-f1', 'a1-b1',
                'a1-c1', 'a1-d1', 'a1-a2', 'a1-a3', 'a1-a4', 'a1-a5',
                'a1-a6', 'a1-a7', 'a1-a8'
              ]}

              let (:check) { false }

              include_examples "legal move examples"
            end

            context 'castle when the rook has moved' do
              let(:board) {
                'r...k...' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '........' +
                '.....K.R' }
              let(:history) { ['a1-a2', 'e8-f8', 'a2-a1'] }

              let(:other_player_legal_moves) {[
                'f8-e8', 'f8-e7', 'f8-f7', 'f8-g7', 'f8-g8',
                'h8-g8', 'h8-h7', 'h8-h6', 'h8-h5', 'h8-h4',
                'h8-h3', 'h8-h2', 'h8-h1'
              ]}
              let(:legal_moves) { [
                'e1-d1', 'e1-d2', 'e1-e2', 'e1-f2', 'e1-f1', 'a1-b1',
                'a1-c1', 'a1-d1', 'a1-a2', 'a1-a3', 'a1-a4', 'a1-a5',
                'a1-a6', 'a1-a7', 'a1-a8'
              ]}

              let (:check) { false }

              include_examples "legal move examples"
            end
          end
        end
      end
    end

    context 'moves that can cause check' do
      context 'pinned piece can\'t move' do
        let(:state_before) {
          { board: '...k....' +
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
          } }
        let(:move) { 'g7-d7' }
        let(:state_after) {
          { board: '...k....' +
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
          } }
        let(:other_player_legal_moves) { [
          'g8-h8', 'g8-h7', 'g8-g7', 'g8-f7', 'g8-f8',
          'd7-a7', 'd7-b7', 'd7-c7', 'd7-e7', 'd7-f7', 'd7-g7', 'd7-h7',
          'd7-d8', 'd7-d6', 'd7-d5', 'd7-d4', 'd7-d3', 'd7-d2'
        ] }

        include_examples "move examples"
      end

      context 'checked player must get out of check' do
        let(:state_before) {
          { board: '...k....' +
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
          } }
        let(:move) { 'f7-f1' }
        let(:state_after) {
          {board:  '...k.R..' +
                   '...n....' +
                   '........' +
                   '........' +
                   '........' +
                   '........' +
                   '........' +
                   '......K.',
            history: ['f7-f1'],
            next_to_move: 0,
            legal_moves: ['d2-f1', 'd1-c2', 'd1-e2'],
            check: true
          } }
        let(:other_player_legal_moves) {[
          'g8-h8', 'g8-h7', 'g8-g7', 'g8-f7', 'g8-f8',
          'f1-d1', 'f1-e1', 'f1-g1', 'f1-h1',
          'f1-f2', 'f1-f3', 'f1-f4', 'f1-f5', 'f1-f6', 'f1-f7', 'f1-f8'
        ]}

        include_examples "move examples"
      end

      context 'check and no legal moves is checkmate' do
        let(:state_before) {
          { board: '...k....' +
                   '..ppp...' +
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
          } }
        let(:move) { 'g7-g1' }
        let(:state_after) {
          { board: '...k..R.' +
                   '..ppp...' +
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
          } }
        let(:other_player_legal_moves) {[
          'g8-h8', 'g8-h7', 'g8-g7', 'g8-f7', 'g8-f8',
          'g1-d1', 'g1-e1', 'g1-f1', 'g1-h1',
          'g1-g2', 'g1-g3', 'g1-g4', 'g1-g5', 'g1-g6', 'g1-g7'
        ]}

        include_examples "move examples"
      end
    end
  end
end
