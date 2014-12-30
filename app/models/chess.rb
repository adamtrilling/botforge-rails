class Chess < Match

  def num_players
    2
  end

  def setup_board
    self.state = Hash[
      'board' => {
        '0' => initial_board_power_pieces('1') + initial_board_pawns('2'),
        '1' => initial_board_power_pieces('8') + initial_board_pawns('7')
      },
      'history' => [],
      'legal_moves' => [
        'pa3', 'pa4', 'pb3', 'pb4', 'pc3', 'pc4',
        'pd3', 'pd4', 'pe3', 'pe4', 'pf3', 'pf4',
        'pg3', 'pg4', 'ph3', 'ph4', 'na3', 'nc3',
        'nf3', 'nh3'
      ],
      'next_to_move' => 0
    ]
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