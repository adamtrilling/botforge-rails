class Chess < Match

  def self.expected_participants
    2
  end

  delegate :max_participants, :min_participants,
    to: :class

  def setup_board
    self.state = Hash[
      'board' => {
        '0' => initial_board_power_pieces('1') + initial_board_pawns('2'),
        '1' => initial_board_power_pieces('8') + initial_board_pawns('7')
      },
      'history' => [],
      'legal_moves' => [
        'a3', 'a4', 'b3', 'b4', 'c3', 'c4',
        'd3', 'd4', 'e3', 'e4', 'f3', 'f4',
        'g3', 'g4', 'h3', 'h4', 'na3', 'nc3',
        'nf3', 'nh3'
      ],
      'next_to_move' => 0
    ]
  end

  def execute_move(move)
    self.state['next_to_move'] = (self.state['next_to_move'] + 1) % 2
    self.state['history'] << move
    save
  end

  private
  def initial_board_pawns(row)
    ('a'..'h').collect {|col| { 'rank' => 'P', 'space' => [col, row]}}
  end

  def initial_board_power_pieces(row)
    [ { 'rank' => 'R', 'space' => ['a', row]},
      { 'rank' => 'N', 'space' => ['b', row]},
      { 'rank' => 'B', 'space' => ['c', row]},
      { 'rank' => 'Q', 'space' => ['d', row]},
      { 'rank' => 'K', 'space' => ['e', row]},
      { 'rank' => 'B', 'space' => ['f', row]},
      { 'rank' => 'N', 'space' => ['g', row]},
      { 'rank' => 'R', 'space' => ['h', row]} ]
  end
end