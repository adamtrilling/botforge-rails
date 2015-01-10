class Chess < Match

  def self.expected_participants
    2
  end

  delegate :max_participants, :min_participants,
    to: :class

  def setup_board
    self.state = Hash[
      'board' =>
        initial_board_power_pieces(0) + initial_board_pawns(0) +
        initial_board_power_pieces(1) + initial_board_pawns(1),
      'history' => [],
      'legal_moves' => [
        'a3', 'a4', 'b3', 'b4', 'c3', 'c4',
        'd3', 'd4', 'e3', 'e4', 'f3', 'f4',
        'g3', 'g4', 'h3', 'h4', 'na3', 'nc3',
        'nf3', 'nh3'
      ],
      'next_to_move' => 0
    ]
  end

  def execute_move(move)
    # pawn
    if (move.size == 2)
      move_pawn(move)
    end

    self.state['next_to_move'] = (self.state['next_to_move'] + 1) % 2
    self.state['history'] << move
    self.state['legal_moves'] = legal_moves(self.state['next_to_move'])
    save
  end

  private
  def initial_board_pawns(seat)
    row = (seat == 0 ? 2 : 7)
    ('a'..'h').collect {|col| { 'seat' => seat, 'rank' => 'pawn', 'space' => [col, row]}}
  end

  def initial_board_power_pieces(seat)
    row = (seat == 0 ? 1 : 8)
    [ { 'seat' => seat, 'rank' => 'rook', 'space' => ['a', row]},
      { 'seat' => seat, 'rank' => 'knight', 'space' => ['b', row]},
      { 'seat' => seat, 'rank' => 'bishop', 'space' => ['c', row]},
      { 'seat' => seat, 'rank' => 'queen', 'space' => ['d', row]},
      { 'seat' => seat, 'rank' => 'king', 'space' => ['e', row]},
      { 'seat' => seat, 'rank' => 'bishop', 'space' => ['f', row]},
      { 'seat' => seat, 'rank' => 'knight', 'space' => ['g', row]},
      { 'seat' => seat, 'rank' => 'rook', 'space' => ['h', row]} ]
  end

  def valid_space?(space)
    space.first >= 'a' && space.first <= 'h' &&
    space.last >= 1 && space.last <= 8
  end

  def pieces_for(seat)
    self.state['board'].select {|piece| piece['seat'] == seat}
  end

  def piece_at(space)
    self.state['board'].select do |piece|
      piece['space'] == space
    end.first
  end

  def occupied?(space)
    piece_at(space).present?
  end

  def capturable?(space, seat)
    piece = piece_at(space)
    piece.present? && piece['seat'] != seat
  end

  def move_pawn(move)
    seat = self.state['next_to_move']
    old_piece_index = state['board'].index do |p|
        p['seat'] == seat &&
        p['rank'] == 'pawn' && p['space'].first == move[0] &&
        (p['space'].last.to_i == move[1].to_i - 1)
    end

    move = move.split('')
    self.state['board'][old_piece_index]['space'] = [move.first, move.last.to_i]
  end

  def legal_moves(seat)
    legal_moves = pieces_for(seat).collect do |piece|
      self.send(:"#{piece['rank']}_legal_moves", piece['space'], seat)
  end

    legal_moves.flatten
  end

  def pawn_legal_moves(space, seat)
    direction = seat == 0 ? 1 : -1
    home_row = seat == 0 ? 2 : 7

    if (space.last == home_row)
      [ "#{space.first}#{home_row + direction}",
        "#{space.first}#{home_row + direction * 2}"]
    else
      "#{space.first}#{space.last + direction}"
    end
  end

  def king_legal_moves(space, seat)
    []
  end

  def queen_legal_moves(space, seat)
    []
  end

  def knight_legal_moves(space, seat)
    [[-2,-1], [-2,1], [-1,-2], [-1,2], [1,-2], [1,2], [2,-1], [2,1]].collect do |move|
      new_space = [(space.first.ord + move.first).chr, space.last + move.last]

      if (!valid_space?(new_space))
        nil
      elsif (capturable?(new_space, seat))
        "nx#{(space.first.ord + move.first).chr}#{space.last + move.last}"
      elsif (!occupied?(new_space))
        "n#{(space.first.ord + move.first).chr}#{space.last + move.last}"
      else
        nil
      end
    end.compact
  end

  def bishop_legal_moves(space, seat)
    []
  end

  def rook_legal_moves(space, seat)
    []
  end
end