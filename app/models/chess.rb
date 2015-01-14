class Chess < Match

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
    coords = move.split('-')
    self.state['board'][coord_to_space(coords[1])] = self.state['board'][coord_to_space(coords[0])]
    self.state['board'][coord_to_space(coords[0])] = '.'

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

  def valid_space?(space)
    (0..63).include?(space)
  end

  def pieces_for(seat)
    self.state['board'].find_chars_where {|p| range_for(seat).include?(p)}
  end

  def piece_at(space)
    self.state['board'][space] == '.' ? nil : self.state['board'][space]
  end

  def occupied?(space)
    piece_at(space) != '.'
  end

  def capturable?(space, seat)
    occupied?(space) && !range_for(seat).include?(piece)
  end

  def legal_moves(seat)
    legal_moves = pieces_for(seat).collect do |space|
      piece = state['board'][space]
      self.send(:"#{piece.downcase}_legal_moves", space, seat)
    end

    legal_moves.flatten
  end

  def p_legal_moves(space, seat)
    direction = seat == 0 ? 1 : -1
    home_row = seat == 0 ? 2 : 7

    origin = space_to_coord(space)

    if (space / 8 + 1 == home_row)
      [ "#{origin}-#{space_to_coord(space + 8 * direction)}",
        "#{origin}-#{space_to_coord(space + 16 * direction)}"]
    else
      "#{origin}-#{space_to_coord(space + 8 * direction)}"
    end
  end

  def k_legal_moves(space, seat)
    []
  end

  def q_legal_moves(space, seat)
    []
  end

  def n_legal_moves(space, seat)
    [[-2,-1], [-2,1], [-1,-2], [-1,2], [1,-2], [1,2], [2,-1], [2,1]].collect do |move|
      # new_space = [(space.first.ord + move.first).chr, space.last + move.last]

      # if (!valid_space?(new_space))
      #   nil
      # elsif (capturable?(new_space, seat))
      #   "nx#{(space.first.ord + move.first).chr}#{space.last + move.last}"
      # elsif (!occupied?(new_space))
      #   "n#{(space.first.ord + move.first).chr}#{space.last + move.last}"
      # else
      #   nil
      # end
    end.compact
  end

  def b_legal_moves(space, seat)
    []
  end

  def r_legal_moves(space, seat)
    []
  end
end