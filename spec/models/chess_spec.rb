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
        'pa3', 'pa4', 'pb3', 'pb4', 'pc3', 'pc4',
        'pd3', 'pd4', 'pe3', 'pe4', 'pf3', 'pf4',
        'pg3', 'pg4', 'ph3', 'ph4', 'na3', 'nc3',
        'nf3', 'nh3'
      ]
    end
  end
end
