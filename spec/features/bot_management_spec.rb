require 'rails_helper'
require 'securerandom'

feature 'Bot management' do
  scenario 'List bots' do
    Given 'I am logged in'
    And 'I have bots'
    When 'I visit the bot list'
    Then 'I am shown a list of my bots'
  end

  scenario 'Create a bot' do
    Given 'I am logged in'
    When 'I visit the bot list'
    And 'I elect to create a bot'
    Then 'I am shown the new bot form'

    When 'I fill in the new bot form'
    Then 'I am shown a list of my bots'
    And 'The list includes the bot I just created'
  end

  scenario 'Edit a bot' do
    Given 'I am logged in'
    And 'I have bots'
    When 'I visit the bot list'
    And 'I elect to edit an existing bot'
    Then 'I am shown the bot edit form'

    When 'I fill in the bot edit form'
    Then 'I am shown a list of my bots'
    And 'The list includes my changes'
  end

  let(:current_user) { FactoryGirl.create(:user) }
  let(:bots) { [
    FactoryGirl.create(:bot, user: current_user),
    FactoryGirl.create(:bot, user: current_user),
    FactoryGirl.create(:bot, user: current_user)
  ] }
  let(:bot_name) { SecureRandom.hex }
  let(:game) { Match::GAMES.keys.sample }

  def i_have_bots
    bots
  end

  def i_visit_the_bot_list
    click_link 'Bots'
  end

  def i_am_shown_a_list_of_my_bots
    current_user.bots.each do |b|
      expect(page).to have_content b.name
    end
  end

  def i_elect_to_create_a_bot
    click_link 'New Bot'
  end

  def i_am_shown_the_new_bot_form
    expect(page).to have_field 'Name'
    expect(page).to have_field 'URL'
    expect(page).to have_field 'Game'
    expect(page).to have_field 'Active', type: 'checkbox'
  end

  def i_fill_in_the_new_bot_form
    fill_in 'Name', with: bot_name
    fill_in 'URL', with: "https://www.example.com/bots/#{bot_name}"
    select game, from: 'Game'

    click_button 'Create Bot'
  end

  def the_list_includes_the_bot_i_just_created
    expect(page).to have_content bot_name
  end

  def i_elect_to_edit_an_existing_bot
    within("#bot-#{bots.first.id}") do
      click_link 'Edit'
    end
  end

  def i_am_shown_the_bot_edit_form
    expect(page).to have_field 'Name'
    expect(page).to have_field 'URL'
    expect(page).to have_field 'Game'
    expect(page).to have_field 'Active', type: 'checkbox'
  end

  def i_fill_in_the_bot_edit_form
    fill_in 'Name', with: bot_name
    fill_in 'URL', with: "https://www.example.com/bots/#{bot_name}"
    select game, from: 'Game'

    click_button 'Update Bot'
  end

  def the_list_includes_my_changes
    expect(page).to have_content bot_name
  end
end