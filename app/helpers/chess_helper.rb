module ChessHelper
  def piece_to_icon(piece)
    if (piece == '.')
      nil
    elsif (('a'..'z').include?(piece))
      "chess-#{piece}-white"
    else
      "chess-#{piece.downcase}-black"
    end
  end

  def square_color(row, col)
    (row + col) % 2 > 0 ? 'light-square' : 'dark-square'
  end
end