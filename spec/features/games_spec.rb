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
      Then "I see the human name of #{game}"
      And "I see a list of top bots at #{game}"
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

  # steps for every game
  Match::GAMES.each do |game, attrs|
    define_method :"i_click_on_#{game.downcase}" do
      click_link attrs[:name]
    end

    define_method :"i_see_the_human_name_of_#{game.downcase}" do
      expect(page).to have_content attrs[:name]
    end

    define_method :"i_see_a_list_of_top_bots_at_#{game.downcase}" do
      expect(page).to have_selector('#leaderboard')
    end

    define_method :"i_see_the_rules_for_#{game.downcase}" do
      expect(page).to have_selector('#rules')
    end

    define_method :"i_see_the_api_for_#{game.downcase}" do
      expect(page).to have_selector('#api')
    end
  end
end