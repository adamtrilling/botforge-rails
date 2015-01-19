module Concerns::Chess::PawnMethods
  extend ActiveSupport::Concern

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

end