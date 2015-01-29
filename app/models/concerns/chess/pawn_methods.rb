module Concerns::Chess::PawnMethods
  extend ActiveSupport::Concern

  def p_direction(seat)
    seat == 0 ? 1 : -1
  end

  def p_legal_moves(space, seat, board)
    legal_moves = []
    if (!occupied?(space + 8 * p_direction(seat), board))
      legal_moves << "#{space}-#{space + 8 * p_direction(seat)}"

      if (space / 8 + 1 == (seat == 0 ? 2 : 7))
        legal_moves << "#{space}-#{space + 16 * p_direction(seat)}"
      end
    end

    legal_moves + p_legal_captures(space, seat, board)
  end

  def p_legal_captures(space, seat, board)
    col = space % 8
    row = space / 8

    legal_moves = []
    [-1,1].each do |direction|
      if ((0..7).include?(col + direction) && capturable?(space + (8 + direction) * p_direction(seat), seat, board))
        legal_moves << "#{space}-#{space + (8 + direction) * p_direction(seat)}"
      end
    end

    legal_moves
  end

end