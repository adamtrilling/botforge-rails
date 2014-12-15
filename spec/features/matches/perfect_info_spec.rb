require 'rails_helper'

feature 'Perfect Information Matches' do
  scenario 'View an in-progress match I am not participating in' do
    Given 'There is an in-progress match'
    When 'I view it'
    Then 'I see the current game state'
    And 'I see the scoreboard'
    And 'I see the list of moves so far'
  end

  scenario 'View an in-progress match I am participating in' do
    Given 'I am logged in'
    And 'There is an in-progress match that I am playing'
    When 'I view the match'
    Then 'I see the current game state'
    And 'I see the scoreboard'
    And 'I see the list of moves so far'
    And 'I can make a move'
  end

  scenario 'View a completed match' do
    Given 'There is a completed match'
    When 'I view it'
    Then 'I see the final game state'
    And 'I see the scoreboard'
    And 'I see the full list of moves'
  end

  let(:current_user) { FactoryGirl.create(:user) }

  def there_is_an_in_progress_match
    @match = FactoryGirl.create(:chess)
  end
end