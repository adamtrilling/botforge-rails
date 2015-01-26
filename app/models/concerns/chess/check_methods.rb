module Concerns::Chess::CheckMethods
  extend ActiveSupport::Concern

  def in_check?(board, seat)
    legal_moves(board.dup, (seat + 1) % 2).any? do |m|
      binding.pry if m == '11-1'
      dest = coord_to_space(m.split('-')[1])
      board[dest].downcase == 'k'
    end
  end
end