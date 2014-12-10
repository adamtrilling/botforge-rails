require 'rails_helper'

feature 'Game Dashboard' do
  scenario do
    Given 'I visit the list of games'
    Then 'I see the list of games'

    When 'I click on a game'
    Then 'I see a list of top bots at the game'
    And 'I see the rules for the game'
    And 'I see the API for the game'
  end
end