module ChessHelper
  def piece_to_icon(piece)
    if (piece == '.')
      nil
    elsif (('a'..'z').include?(piece))
      "icon-chess-#{piece} white"
    else
      "icon-chess-#{piece.downcase} black"
    end
  end
end