class Chess < Match
  before_create :setup_board

  private
  def setup_board
    self.board = Hash[
      'current' => {
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
          '1' => { 'piece' => 'Kn', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'Kn', 'color' => 'B' }
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
          '1' => { 'piece' => 'Kn', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'Kn', 'color' => 'B' }
        },
        'h' => {
          '1' => { 'piece' => 'R', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'R', 'color' => 'B' }
        },
      },
      'history' => []
    ]
  end
end