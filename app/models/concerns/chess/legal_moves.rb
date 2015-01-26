module Concerns::Chess::LegalMoves
  extend ActiveSupport::Concern
  include Concerns::Chess::PawnMethods

  def legal_moves(board, seat, self_check = false)
    local_board = board.dup

    moves = pieces_for(local_board, seat).collect do |space|
      piece = local_board[space]
      self.send(:"#{piece.downcase}_legal_moves", space, seat)
    end.flatten

    # filter out same-color-occupied spaces
    moves.select! do |m|
      can_move_to?(m.split('-')[1].to_i, seat)
    end

    # filter out moves that would leave you in check
    if (self_check)
      moves.reject! do |m|
        puts "move: #{m.split('-').map {|s| space_to_coord(s.to_i)}.join('-')} (#{m})"
        puts "old board: #{local_board}"
        puts "new board: #{move_pieces(m, local_board.dup, seat)}"
        puts "in check?: #{in_check?(move_pieces(m, local_board.dup, seat), seat)}"
        binding.pry if m == '11-1'
        new_board = move_pieces(m, local_board.dup, seat)
        in_check?(new_board, seat)
      end
    end

    moves.collect do |m|
      # convert space numbers into moves
      m.split('-').map {|s| space_to_coord(s.to_i)}.join('-')
    end
  end

  private

  def pieces_for(board, seat)
    board.find_chars_where {|p| range_for(seat).include?(p)}
  end

  def piece_at(space)
    state['board'][space] == '.' ? nil : state['board'][space]
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

  def k_legal_moves(space, seat)
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

    # this would be a nice spot for a traditional for loop, which
    # ruby does not support
    row = space / 8 + dir[0]
    col = space % 8 + dir[1]

    while ((0..7).include?(row) &&
           (0..7).include?(col))
      if (can_move_to?(row * 8 + col, seat))
        legal_moves << "#{space}-#{(row * 8) + col}"
      end
      if (occupied?(row * 8 + col))
        break
      end

      row += dir[0]
      col += dir[1]
    end

    legal_moves
  end
end