class Chess < Match
  before_create :setup_board

  private
  def setup_board
    self.board = Hash[
      'current' => {
        'a' => {
          '1' => { 'piece' => 'R', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'R', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        },
        'b' => {
          '1' => { 'piece' => 'B', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'B', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        },
        'c' => {
          '1' => { 'piece' => 'Kn', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'Kn', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        },
        'd' => {
          '1' => { 'piece' => 'Q', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'Q', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        },
        'e' => {
          '1' => { 'piece' => 'K', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'K', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        },
        'f' => {
          '1' => { 'piece' => 'B', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'B', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        },
        'g' => {
          '1' => { 'piece' => 'Kn', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'Kn', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        },
        'h' => {
          '1' => { 'piece' => 'R', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'R', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        },
      },
      'history' => []
    ]
  end
end