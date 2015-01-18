class Chess < Match
  include Concerns::Chess::LegalMoves

  def self.expected_participants
    2
  end

  delegate :max_participants, :min_participants,
    to: :class

  def setup_board
    self.state = Hash[
      'board' => 'rnbqkbnrpppppppp' + ('.' * 32) + 'PPPPPPPPRNBQKBNR',
      'history' => [],
      'legal_moves' => [
        'a2-a3', 'a2-a4', 'b2-b3', 'b2-b4', 'c2-c3', 'c2-c4',
        'd2-d3', 'd2-d4', 'e2-e3', 'e2-e4', 'f2-f3', 'f2-f4',
        'g2-g3', 'g2-g4', 'h2-h3', 'h2-h4', 'b2-a3', 'b2-c3',
        'g2-f3', 'g2-h3'
      ],
      'next_to_move' => 0
    ]
  end

  def execute_move(move)
    move_pieces(move)

    self.state['next_to_move'] = (self.state['next_to_move'] + 1) % 2
    self.state['history'] << move
    self.state['legal_moves'] = legal_moves(self.state['next_to_move'])
    save
  end

  private
  def space_to_coord(space)
    ('a'.ord + space % 8).chr + (space / 8 + 1).to_s
  end

  def coord_to_space(coord)
    (coord[1].to_i - 1) * 8 + coord[0].ord - 'a'.ord
  end

  def range_for(seat)
    seat == 0 ? ('a'..'z') : ('A'..'Z')
  end

  def rank_for_player(rank, seat)
    seat == 0 ? rank.downcase : rank.upcase
  end

  def move_pieces(move)
    coords = move.split('-')
    origin = coord_to_space(coords[0])
    destination = coord_to_space(coords[1])

    # check for pawn promotion
    if (self.state['board'][origin].downcase == 'p' && ([0, 8]).include?(destination / 7))
      self.state['board'][destination] = rank_for_player(coords[2], self.state['next_to_move'])
    else
      self.state['board'][destination] = self.state['board'][origin]
    end
    self.state['board'][origin] = '.'
  end
end