module Concerns::Chess::LegalMoves
  extend ActiveSupport::Concern

  def legal_moves(board, seat, self_check = false)
    local_board = board.dup

    moves = pieces_for(local_board, seat).collect do |space|
      piece = local_board[space]
      self.send(:"#{piece.downcase}_legal_moves", space, seat, local_board)
    end.flatten

    # filter out same-color-occupied spaces
    moves.select! do |m|
      can_move_to?(m.split('-')[1].to_i, seat)
    end

    # filter out moves that would leave you in check
    if (self_check)
      moves.reject! do |m|
        new_board = move_pieces(m, local_board.dup, seat)
        in_check?(new_board, seat)
      end
    end

    spaces_to_coords(moves)
  end

  private

  def home_row(seat)
    seat == 0 ? 1 : 8
  end

  def pieces_for(board, seat)
    board.find_chars_where {|p| range_for(seat).include?(p)}
  end

  def piece_at(space, board = state['board'])
    board[space] == '.' ? nil : board[space]
  end

  def occupied?(space, board = state['board'])
    piece_at(space, board).present?
  end

  def capturable?(space, seat, board = state['board'])
    occupied?(space, board) && !range_for(seat).include?(piece_at(space, board))
  end

  def can_move_to?(space, seat, board = state['board'])
    !occupied?(space, board) || capturable?(space, seat, board)
  end

  def q_legal_moves(space, seat, board = state['board'])
    b_legal_moves(space, seat) + r_legal_moves(space, seat)
  end

  def n_legal_moves(space, seat, board = state['board'])
    [[-2,-1], [-2,1], [-1,-2], [-1,2], [1,-2], [1,2], [2,-1], [2,1]].collect do |move|
      row = (space / 8) + move[0]
      col = (space % 8) + move[1]

      "#{space}-#{(row * 8) + col}" if ((0..7).include?(row) && (0..7).include?(col))
    end.compact
  end

  def b_legal_moves(space, seat, board = state['board'])
    [-1,1].product([-1,1]).collect do |dir|
      move_along_line(space, seat, dir, board)
    end.flatten
  end

  def r_legal_moves(space, seat, board = state['board'])
    [[-1, 0], [1, 0], [0, -1], [0, 1]].collect do |dir|
      move_along_line(space, seat, dir, board)
    end.flatten
  end

  def move_along_line(space, seat, dir, board = state['board'])
    legal_moves = []

    # this would be a nice spot for a traditional for loop, which
    # ruby does not support
    row = space / 8 + dir[0]
    col = space % 8 + dir[1]

    while ((0..7).include?(row) &&
           (0..7).include?(col))
      if (can_move_to?(row * 8 + col, seat, board))
        legal_moves << "#{space}-#{(row * 8) + col}"
      end
      if (occupied?(row * 8 + col, board))
        break
      end

      row += dir[0]
      col += dir[1]
    end

    legal_moves
  end
end