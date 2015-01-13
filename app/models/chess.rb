class Chess < Match

  def self.expected_participants
    2
  end

  delegate :max_participants, :min_participants,
    to: :class

  def setup_board
    self.state = Hash[
      'board' => 'rnbqkbnrpppppppp' + ('.' * 48) + 'PPPPPPPPRNBQKBNR',
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
    # pawn
    if (move.size == 2)
      move_pawn(move)
    end

    self.state['next_to_move'] = (self.state['next_to_move'] + 1) % 2
    self.state['history'] << move
    self.state['legal_moves'] = legal_moves(self.state['next_to_move'])
    save
  end

  private

  def range_for(seat)
    seat == 0 ? ('a'..'z') : ('A'..'Z')
  end

  def capitalize(rank, seat)
    if (seat == 1)
      rank.upcase
    else
      rank
    end
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

  def move_pawn(move)
    seat = self.state['next_to_move']
    move_col = move[0].ord - 'a'.ord
    move_row = move[1].to_i

    if (piece_at((move_row - 1) * 8 + move_col))
      self.state['board'][(move_row - 1) * 8 + move_col] = capitalize('p', seat)
    else
      self.state['board'][(move_row - 2) * 8 + move_col] = capitalize('p', seat)
    end
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

    col = 'a'.ord + (space % 8)
    row = space / 8

    if (row == home_row)
      [ "#{col}#{home_row + direction}",
        "#{col}#{home_row + direction * 2}"]
    else
      "#{col}#{row + direction}"
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