class Chess < Match
  include Concerns::Chess::LegalMoves
  include Concerns::Chess::EndgameMethods
  include Concerns::Chess::PawnMethods
  include Concerns::Chess::KingMethods

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
    raise IllegalMove unless self.state['legal_moves'].include?(move)

    self.state['board'] = move_pieces(move, state['board'], state['next_to_move'])

    self.state['next_to_move'] = (state['next_to_move'] + 1) % 2
    self.state['history'] << move
    self.state['legal_moves'] = legal_moves(state['board'], state['next_to_move'], true)
    self.state['check'] = in_check?(state['board'], state['next_to_move'])

    save
  end

  private
  def space_to_coord(space)
    ('a'.ord + space % 8).chr + (space / 8 + 1).to_s
  end

  def coord_to_space(coord)
    (coord[1].to_i - 1) * 8 + coord[0].ord - 'a'.ord
  end

  def spaces_to_coords(list)
    list.collect do |m|
      # convert space numbers into moves
      m.split('-').map do |s|
        if (s == 'o')
          'o'
        else
          space_to_coord(s.to_i)
        end
      end.join('-')
    end
  end

  def range_for(seat)
    seat == 0 ? ('a'..'z') : ('A'..'Z')
  end

  def rank_for_player(rank, seat)
    seat == 0 ? rank.downcase : rank.upcase
  end

  def move_pieces(move, board, next_to_move)
    coords = move.split('-')

    if (coords.all? {|c| c == 'o'})
      return do_castle(move, board, next_to_move)
    end

    if (('a'..'h').include?(move[0]))
      origin = coord_to_space(coords[0])
      destination = coord_to_space(coords[1])
    else
      origin = coords[0].to_i
      destination = coords[1].to_i
    end

    # check for pawn promotion
    if (board[origin].downcase == 'p' && ([0, 8]).include?(destination / 7))
      board[destination] = rank_for_player(coords[2], next_to_move)
    else
      board[destination] = board[origin]
    end
    board[origin] = '.'

    board
  end

  def do_castle(move, board, seat)
    if (move == 'o-o')
      # king-side
      board[(home_row(seat) - 1) * 8 + 4] = '.'
      board[(home_row(seat) - 1) * 8 + 6] = rank_for_player('k', seat)
      board[(home_row(seat) - 1) * 8 + 7] = '.'
      board[(home_row(seat) - 1) * 8 + 5] = rank_for_player('r', seat)
    else
      # queen-side
      board[(home_row(seat) - 1) * 8 + 4] = '.'
      board[(home_row(seat) - 1) * 8 + 2] = rank_for_player('k', seat)
      board[(home_row(seat) - 1) * 8 + 0] = '.'
      board[(home_row(seat) - 1) * 8 + 3] = rank_for_player('r', seat)
    end

    board
  end
end