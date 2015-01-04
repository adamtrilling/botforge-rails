class Human < Player
  validates :game,
    uniqueness: { scope: :user_id,
      message: "must be unique per-user" 
    }

  # human players act as delayed-response bots
  def request_move
    return true
  end
end