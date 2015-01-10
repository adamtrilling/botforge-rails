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
    ('a'..'h').collect {|col| { 'participant' => participant, 'rank' => 'P', 'space' => [col, row]}}
  end

  def initial_board_power_pieces(participant)
    row = (participant == 0 ? 1 : 8)
    [ { 'participant' => participant, 'rank' => 'R', 'space' => ['a', row]},
      { 'participant' => participant, 'rank' => 'N', 'space' => ['b', row]},
      { 'participant' => participant, 'rank' => 'B', 'space' => ['c', row]},
      { 'participant' => participant, 'rank' => 'Q', 'space' => ['d', row]},
      { 'participant' => participant, 'rank' => 'K', 'space' => ['e', row]},
      { 'participant' => participant, 'rank' => 'B', 'space' => ['f', row]},
      { 'participant' => participant, 'rank' => 'N', 'space' => ['g', row]},
      { 'participant' => participant, 'rank' => 'R', 'space' => ['h', row]} ]
  end

  def pieces_for(participant)
    self.state['board'].select {|piece| piece['participant'] == participant}
  end

  def move_pawn(move)
    participant = self.state['next_to_move']
    old_piece_index = state['board'].index do |p|
        p['participant'] == participant &&
        p['rank'] == 'P' && p['space'].first == move[0] &&
        (p['space'].last.to_i == move[1].to_i - 1)
    end

    move = move.split('')
    self.state['board'][old_piece_index]['space'] = [move.first, move.last.to_i]
  end

  def legal_moves(participant)
    legal_moves = []

    pieces_for(participant).each do |piece|
      case piece['rank']
      when 'P'
        legal_moves << pawn_legal_moves(piece['space'], participant)
      when 'N'
        legal_moves << knight_legal_moves(piece['space'])
      end
    end

    legal_moves.flatten
  end

  def pawn_legal_moves(space, participant)
    if (participant == 0)
      if (space.last == 2)
        ["#{space.first}3", "#{space.first}4"]
      else
        "#{space.first}#{space.last + 1}"
      end
    else
      if (space.last == 7)
        ["#{space.first}6", "#{space.first}5"]
      else
        "#{space.first}#{space.last - 1}"
      end
    end
  end

  def knight_legal_moves(space)
    [[-2,-1], [-2,1], [-1,-2], [-1,2], [1,-2], [1,2], [2,-1], [2,1]].collect do |move|
      if (space.first.ord + move.first >= 'a'.ord && space.first.ord + move.first <= 'h'.ord &&
          space.last + move.last >= 1 && space.last + move.last <= 8)
        "n#{(space.first.ord + move.first).chr}#{space.last + move.last}"
      else
        nil
      end
    end.compact
  end
end