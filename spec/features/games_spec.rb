require 'rails_helper'

feature 'Game Dashboard' do
  scenario do
    Given 'I visit the list of games'
    Then 'I see the list of games'
  end

  Match::GAMES.each do |game, attrs|
    scenario do
      Given 'I visit the list of games'
      When "I click on #{game}"
      Then "I see a list of top bots at #{game}"
      And "I see the rules for #{game}"
      And "I see the API for #{game}"
    end
  end

  def i_visit_the_list_of_games
    visit games_path
  end

  def i_see_the_list_of_games
    Match::GAMES.each do |game, attrs|
      expect(page).to have_content attrs[:name]
    end
  end

  Match::GAMES.each do |game, attrs|
    define_method :"i_click_on_#{game}" do
      click_link attrs[:name]
    end
  end
end