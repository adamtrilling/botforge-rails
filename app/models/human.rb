class Human < Player
  validates :game,
    uniqueness: { scope: :user_id,
      message: "must be unique per-user" 
    }
end