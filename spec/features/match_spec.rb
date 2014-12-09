require 'rails_helper'

feature 'View a completed match' do
  Given 'There is a completed match'
  When 'I view it'
  Then 'I see the final game state'
  And 'I see the scoreboard'
  And 'I see the full list of moves'
end

feature 'View an in-progress match I am not participating in' do
  Given 'There is an in-progress match'
  
end