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
  def initial_board_pawns(participant)
    row = (participant == 0 ? 2 : 7)
    ('a'..'h').collect {|col| { 'participant' => participant, 'rank' => 'pawn', 'space' => [col, row]}}
  end

  def initial_board_power_pieces(participant)
    row = (participant == 0 ? 1 : 8)
    [ { 'participant' => participant, 'rank' => 'rook', 'space' => ['a', row]},
      { 'participant' => participant, 'rank' => 'knight', 'space' => ['b', row]},
      { 'participant' => participant, 'rank' => 'bishop', 'space' => ['c', row]},
      { 'participant' => participant, 'rank' => 'queen', 'space' => ['d', row]},
      { 'participant' => participant, 'rank' => 'king', 'space' => ['e', row]},
      { 'participant' => participant, 'rank' => 'bishop', 'space' => ['f', row]},
      { 'participant' => participant, 'rank' => 'knight', 'space' => ['g', row]},
      { 'participant' => participant, 'rank' => 'rook', 'space' => ['h', row]} ]
  end

  def pieces_for(participant)
    self.state['board'].select {|piece| piece['participant'] == participant}
  end

  def occupied?(space)
    self.state['board'].select do |piece|
      piece['space'] == space
    end.size > 0
  end

  def capturable?(space, participant)
    self.state['board'].select do |piece|
      piece['space'] == space &&
      piece['participant'] != participant
    end.size > 0
  end

  def valid_space?(space)
    space.first >= 'a' && space.first <= 'h' &&
    space.last >= 1 && space.last <= 8
  end

  def move_pawn(move)
    participant = self.state['next_to_move']
    old_piece_index = state['board'].index do |p|
        p['participant'] == participant &&
        p['rank'] == 'pawn' && p['space'].first == move[0] &&
        (p['space'].last.to_i == move[1].to_i - 1)
    end

    move = move.split('')
    self.state['board'][old_piece_index]['space'] = [move.first, move.last.to_i]
  end

  def legal_moves(participant)
    legal_moves = pieces_for(participant).collect do |piece|
      self.send(:"#{piece['rank']}_legal_moves", piece['space'], participant)
    end

    legal_moves.flatten
  end

  def pawn_legal_moves(space, participant)
    direction = participant == 0 ? 1 : -1
    home_row = participant == 0 ? 2 : 7

    if (space.last == home_row)
      [ "#{space.first}#{home_row + direction}",
        "#{space.first}#{home_row + direction * 2}"]
    else
      "#{space.first}#{space.last + direction}"
    end
  end

  def king_legal_moves(space, participant)
    []
  end

  def queen_legal_moves(space, participant)
    []
  end

  def knight_legal_moves(space, participant)
    [[-2,-1], [-2,1], [-1,-2], [-1,2], [1,-2], [1,2], [2,-1], [2,1]].collect do |move|
      new_space = [(space.first.ord + move.first).chr, space.last + move.last]
      if (valid_space?(new_space) && !occupied?(new_space))
        "n#{(space.first.ord + move.first).chr}#{space.last + move.last}"
      elsif (valid_space?(new_space) && capturable?(new_space, participant))
        "nx#{(space.first.ord + move.first).chr}#{space.last + move.last}"
      else
        nil
      end
    end.compact
  end

  def bishop_legal_moves(space, participant)
    []
  end

  def rook_legal_moves(space, participant)
    []
  end


end