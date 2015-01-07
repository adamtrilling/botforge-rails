class Chess < Match

  def self.expected_participants
    2
  end

  delegate :max_participants, :min_participants,
    to: :class

  def setup_board
    self.state = Hash[
      'board' => {
        '0' => initial_board_power_pieces('1') + initial_board_pawns('2'),
        '1' => initial_board_power_pieces('8') + initial_board_pawns('7')
      },
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
    self.state['legal_moves'] == legal_moves(self.state['next_to_move'])
    save
  end

  private
  def initial_board_pawns(row)
    ('a'..'h').collect {|col| { 'rank' => 'P', 'space' => [col, row]}}
  end

  def initial_board_power_pieces(row)
    [ { 'rank' => 'R', 'space' => ['a', row]},
      { 'rank' => 'N', 'space' => ['b', row]},
      { 'rank' => 'B', 'space' => ['c', row]},
      { 'rank' => 'Q', 'space' => ['d', row]},
      { 'rank' => 'K', 'space' => ['e', row]},
      { 'rank' => 'B', 'space' => ['f', row]},
      { 'rank' => 'N', 'space' => ['g', row]},
      { 'rank' => 'R', 'space' => ['h', row]} ]
  end

  def move_pawn(move)
    player = self.state['next_to_move']
    pieces = self.state['board'][player.to_s]
    old_piece_index = pieces.index do |p|
      p['rank'] == 'P' && p['space'].first == move[0] && (p['space'].last.to_i == move[1].to_i - 1)
    end

    self.state['board'][player.to_s][old_piece_index]['space'] = move.split('')
  end

  def legal_moves(participant)
    legal_moves = []

    state['board'][participant.to_s].each do |piece|
      case piece['rank']
      when 'P'
        legal_moves << pawn_legal_moves(piece['space'], participant)
      end
    end

    legal_moves.flatten
  end

  def pawn_legal_moves(space, participant)
    if (participant == 0)
      if (space.last == '2')
        [space.first + '3', space.first + '4']
      else
        space.first + (space.last.ord + 1).chr
      end
    else
      if (space.last == '7')
        [space.first + '6', space.first + '5']
      else
        space.first + (space.last.ord - 1).chr
      end
    end
  end
end