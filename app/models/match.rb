class Match < ActiveRecord::Base
  GAMES = {
    'Holdem' => {
      name: 'Texas Hold\'em Poker'  
    },
    'Go' => {
      name: 'Go'
    },
    'Chess' => {
      name: 'Chess'
    },
    'Hearts' => {
      name: 'Hearts'
    }
  }

  has_many :participants

  validates :type,
    inclusion: {in: GAMES.keys}

  def has_participants?
    participants.size == num_players
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

    return has_participants?
  end

  private
  def max_participants
    num_players.is_a?(Hash) ? num_players[:max] : num_players
  end

  def max_participants
    num_players.is_a?(Hash) ? num_players[:min] : num_players
  end
end