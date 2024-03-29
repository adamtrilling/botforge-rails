require 'rails_helper'

feature 'Chess Matches' do
  scenario 'Start a match' do
    Given 'I am logged in'
    And 'There is a chess bot'
    When 'I visit the chess page'
    And 'I click Request Match'
    Then 'I am shown the match'
  end

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

    When 'I make a move'
    Then 'I see the results of the move'
    And 'I can not make a move'
  end

  scenario 'View a completed match' do
    Given 'There is a completed match'
    When 'I view it'
    Then 'I see the final game state'
    And 'I see the scoreboard'
    And 'I see the full list of moves'
  end

  let(:current_user) { FactoryGirl.create(:user) }
  let(:chess_bot) { FactoryGirl.create(:bot, :chess) }

  def there_is_a_chess_bot
    chess_bot
  end

  def i_visit_the_chess_page
    visit game_path('Chess')
  end

  def i_click_request_match
    click_button 'Request Match'
    @match = current_user.humans.first.participants.first.match
  end

  def there_is_an_in_progress_match
    @match = FactoryGirl.create(:chess)
  end

  def i_am_shown_the_match
    within('#info') do
      expect(page).to have_text("Chess Match #{@match.id}")
      @match.participants.each do |p|
        expect(page).to have_text(p.player.name)
        expect(page).to have_text(p.player.rating)
      end
    end

    within('#board') do
      within('[data-row="1"][data-col="a"]') do
        expect(page).to have_selector('i.icon-chess-r.white')
      end

      within('[data-row="1"][data-col="e"]') do
        expect(page).to have_selector('i.icon-chess-k.white')
      end

      within('[data-row="1"][data-col="g"]') do
        expect(page).to have_selector('i.icon-chess-n.white')
      end

      within('[data-row="2"][data-col="a"]') do
        expect(page).to have_selector('i.icon-chess-p.white')
      end

      within('[data-row="8"][data-col="a"]') do
        expect(page).to have_selector('i.icon-chess-r.black')
      end

      within('[data-row="8"][data-col="f"]') do
        expect(page).to have_selector('i.icon-chess-b.black')
      end

      within('[data-row="7"][data-col="c"]') do
        expect(page).to have_selector('i.icon-chess-p.black')
      end
    end
  end
end