class Match < ActiveRecord::Base
  GAMES = {
    # 'Holdem' => {
    #   name: 'Texas Hold\'em Poker'
    # },
    # 'Go' => {
    #   name: 'Go'
    # },
    # 'Hearts' => {
    #   name: 'Hearts'
    # },
    'Chess' => {
      name: 'Chess'
    }
  }

  has_many :participants

  validates :type,
    inclusion: {in: GAMES.keys}

  def start_match
    invite_participants unless has_participants?
    setup_board
    update_attributes(status: 'in progress')
  end

  def has_participants?
    participants.size <= max_participants && participants.size >= min_participants
  end

  def invite_participants
    Bot.where(game: type, active: true).order("RANDOM()").each do |b|
      if (b.invite(self))
        self.participants.build(
          player_id: b.id
        )
      end

      break if self.participants.size == max_participants
    end

    if (!has_participants?)
      participants.shuffle.each_with_index do |p, i|
        p.update_attributes(seat: i)
      end
    end

    return has_participants?
  end

  def next_player_to_move
    participants.find_by(seat: state['next_to_move']).player
  end

  def request_move
    next_player_to_move.request_move(self)
  end

  class << self
    def max_participants
      expected_participants.is_a?(Hash) ? expected_participants[:max] : expected_participants
    end

    def min_participants
      expected_participants.is_a?(Hash) ? expected_participants[:min] : expected_participants
    end
  end

  delegate :max_participants, :min_participants,
    to: :class
end

class IllegalMove < ArgumentError

end