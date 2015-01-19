module Concerns::Chess::LegalMoves
  extend ActiveSupport::Concern

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

  private

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

  def can_move_to?(space, seat)
    !occupied?(space) || capturable?(space, seat)
  end

  def legal_destination?(space, seat)
    (capturable?(space, seat) || !occupied?(space))
  end

  def p_direction(seat)
    seat == 0 ? 1 : -1
  end

  def p_legal_moves(space, seat)
    legal_moves = []
    if (!occupied?(space + 8 * p_direction(seat)))
      legal_moves << "#{space}-#{space + 8 * p_direction(seat)}"

      if (space / 8 + 1 == (seat == 0 ? 2 : 7))
        legal_moves << "#{space}-#{space + 16 * p_direction(seat)}"
      end
    end

    legal_moves + p_legal_captures(space, seat)
  end

  def p_legal_captures(space, seat)
    col = space % 8

    legal_moves = []
    if (col > 0 && capturable?(space + 7 * p_direction(seat), seat))
      legal_moves << "#{space}-#{space + 7 * p_direction(seat)}"
    end
    if (col < 7 && capturable?(space + 9 * p_direction(seat), seat))
      legal_moves << "#{space}-#{space + 9 * p_direction(seat)}"
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

      "#{space}-#{(row * 8) + col}" if ((0..7).include?(row) && (0..7).include?(col))
    end.compact
  end

  def b_legal_moves(space, seat)
    [-1,1].product([-1,1]).collect do |dir|
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
           (0..7).include?(new_col))
      if (can_move_to?(new_row * 8 + new_col, seat))
        legal_moves << "#{space}-#{(new_row * 8) + new_col}"
      end
      if (occupied?(new_row * 8 + new_col))
        break
      end

      new_row += dir[0]
      new_col += dir[1]
    end

    legal_moves
  end
end