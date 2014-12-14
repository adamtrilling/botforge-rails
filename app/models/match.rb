class Match < ActiveRecord::Base
  GAMES = {
    'holdem_poker' => {
      name: 'Texas Hold\'em Poker'  
    },
    'go' => {
      name: 'Go'
    },
    'chess' => {
      name: 'Chess'
    },
    'hearts' => {
      name: 'Hearts'
    }
  }
end