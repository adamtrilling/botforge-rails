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

    origin = coord_to_space(coords[0])
    destination = coord_to_space(coords[1])

    # check for pawn promotion
    if (self.state['board'][origin].downcase == 'p' && ([0, 8]).include?(destination / 7))
      self.state['board'][destination] = rank_for_player(coords[2], self.state['next_to_move'])
    else
      self.state['board'][destination] = self.state['board'][origin]
    end
    self.state['board'][origin] = '.'


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

  def pieces_for(seat)
    self.state['board'].find_chars_where {|p| range_for(seat).include?(p)}
  end

  def piece_at(space)
    self.state['board'][space] == '.' ? nil : self.state['board'][space]
  end

  def occupied?(space)
    piece_at(space).present?
  end

  def capturable?(space, seat)
    occupied?(space) && !range_for(seat).include?(piece_at(space))
  end

  def legal_destination?(space, seat)
    (capturable?(space, seat) || !occupied?(space))
  end

  def legal_moves(seat)
    legal_moves = pieces_for(seat).collect do |space|
      piece = state['board'][space]
      self.send(:"#{piece.downcase}_legal_moves", space, seat)
    end

    legal_moves.flatten.select do |m|
      # filter out same-color-occupied spaces
      legal_destination?(m.split('-')[1].to_i, seat)
    end.collect do |m|
      # convert space numbers into moves
      m.split('-').map {|s| space_to_coord(s.to_i)}.join('-')
    end
  end

  def p_legal_moves(space, seat)
    direction = seat == 0 ? 1 : -1
    home_row = seat == 0 ? 2 : 7
    col = space % 8

    legal_moves = []
    if (!occupied?(space + 8 * direction))
      legal_moves << "#{space}-#{space + 8 * direction}"

      if (space / 8 + 1 == home_row)
        legal_moves << "#{space}-#{space + 16 * direction}"
      end
    end

    # capture possibilities
    if (col > 0 && capturable?(space + 7 * direction, seat))
      legal_moves << "#{space}-#{space + 7 * direction}"
    end
    if (col < 7 && capturable?(space + 9 * direction, seat))
      legal_moves << "#{space}-#{space + 9 * direction}"
    end

    legal_moves
  end

  def k_legal_moves(space, seat)
    row = space / 8
    col = space % 8

    legal_moves = []

    [-1, 0, 1].each do |x|
      [-1, 0, 1].each do |y|
        if ((0..7).include?(col + x) && (0..7).include?(row + y))
          legal_moves << "#{space}-#{space + (8 * y) + x}"
        end
      end
    end

    legal_moves
  end

  def q_legal_moves(space, seat)
    b_legal_moves(space, seat) + r_legal_moves(space, seat)
  end

  def n_legal_moves(space, seat)
    [[-2,-1], [-2,1], [-1,-2], [-1,2], [1,-2], [1,2], [2,-1], [2,1]].collect do |move|
      row = (space / 8) + move[0]
      col = (space % 8) + move[1]

      if (!(0..7).include?(row) || !(0..7).include?(col))
        nil
      else
        "#{space}-#{(row * 8) + col}"
      end
    end.compact
  end

  def b_legal_moves(space, seat)
    [[-1, -1], [-1, 1], [1, -1], [1, 1]].collect do |dir|
      move_along_line(space, seat, dir)
    end.flatten
  end

  def r_legal_moves(space, seat)
    [[-1, 0], [1, 0], [0, -1], [0, 1]].collect do |dir|
      move_along_line(space, seat, dir)
    end.flatten
  end

  def move_along_line(space, seat, dir)
    legal_moves = []

    row = space / 8
    col = space % 8

    new_row = row + dir[0]
    new_col = col + dir[1]

    while ((0..7).include?(new_row) &&
           (0..7).include?(new_col) &&
           !occupied?(new_row * 8 + new_col))
      legal_moves << "#{space}-#{(new_row * 8) + new_col}"

      new_row += dir[0]
      new_col += dir[1]
    end

    if ((0..7).include?(new_row) &&
        (0..7).include?(new_col) &&
        capturable?(new_row * 8 + new_col, seat))
      legal_moves << "#{space}-#{(new_row * 8) + new_col}"
    end

    legal_moves
  end
end