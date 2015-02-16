module Concerns::Chess::KingMethods
  extend ActiveSupport::Concern

  def k_legal_moves(space, seat, board = state['board'])
    row = space / 8
    col = space % 8

    legal_moves = []

    [-1, 0, 1].each do |x|
      [-1, 0, 1].each do |y|
        next if (x == 0 && y == 0)
        if ((0..7).include?(col + x) && (0..7).include?(row + y))
          legal_moves << "#{space}-#{space + (8 * y) + x}"
        end
      end
    end

    # castling
    if (space == coord_to_space("e#{home_row(seat)}"))
      if (can_castle?(board, seat, 'king'))
        legal_moves << "o-o"
      end
      if (can_castle?(board, seat, 'queen'))
        legal_moves << "o-o-o"
      end
    end

    legal_moves
  end

  def potential_castles(seat)
    ['c', 'g'].collect {|n| "e#{home_row(seat)}-#{n}#{home_row(seat)}"}
  end

  def can_castle?(board, seat, side)
    rook_col = (side == 'king' ? 'h' : 'a')
    castle_range = (side == 'king' ? ('f'..'g') : ('b'..'d'))

    # the rook hasn't moved
    board[(home_row(seat) - 1) * 8 + (rook_col.ord - 'a'.ord)] == rank_for_player('r', seat) &&
    state['history'].none? do |m|
      m.split('-')[0] == "#{rook_col}#{home_row(seat)}"
    end &&

    # king hasn't moved
    board[(home_row(seat) - 1) * 8 + 4] == rank_for_player('k', seat) &&
    state['history'].none? do |m|
      m.split('-')[0] == "e#{home_row(seat)}"
    end &&

    # there are no pieces between the rook and the king
    castle_range.all? do |s|
      board[coord_to_space("#{s}#{home_row(seat)}")] == '.'
    end &&

    # can't castle out of check
    !self.state['check']

    # can't castle through check
    # TODO
  end
end