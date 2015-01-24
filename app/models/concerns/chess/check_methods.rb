module Concerns::Chess::CheckMethods
  extend ActiveSupport::Concern

  def in_check?(board, seat)
    legal_moves(board, seat + 1 % 2).any? do |m|
      dest = coord_to_space(m.split('-')[1])
      board[dest].downcase == 'k'
    end
  end
end