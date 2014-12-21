class Chess < Match
  private
  def setup_board
    self.state = Hash[
      'board' => {
        'a' => {
          '1' => { 'piece' => 'R', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'R', 'color' => 'B' }
        },
        'b' => {
          '1' => { 'piece' => 'B', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'B', 'color' => 'B' }
        },
        'c' => {
          '1' => { 'piece' => 'N', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'N', 'color' => 'B' }
        },
        'd' => {
          '1' => { 'piece' => 'Q', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'Q', 'color' => 'B' }
        },
        'e' => {
          '1' => { 'piece' => 'K', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'K', 'color' => 'B' }
        },
        'f' => {
          '1' => { 'piece' => 'B', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'B', 'color' => 'B' }
        },
        'g' => {
          '1' => { 'piece' => 'N', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'N', 'color' => 'B' }
        },
        'h' => {
          '1' => { 'piece' => 'R', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'R', 'color' => 'B' }
        },
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
end