class Match < ActiveRecord::Base
  GAMES = {
    holdem_poker: {
      name: 'Texas Hold\'em Poker'  
    },
    seven_stud_poker: {
      name: 'Seven-Card Stud Poker'
    },
    go: {
      name: 'Go'
    },
    chess: {
      name: 'Chess'
    },
    hearts: {
      name: 'Hearts'
    }
  }
end