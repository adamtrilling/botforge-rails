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
end