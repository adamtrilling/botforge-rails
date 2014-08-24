require 'rails_helper'

feature "Bot management" do
  scenario "List bots" do
    Given "I am logged in"
    And "I have bots"
    When "I visit the bot list"
    Then "I am shown a list of my bots"
  end

  scenario "Create a bot" do
    Given "I am logged in"
    When "I visit the bot list"
    And "I elect to create a bot"
    Then "I am shown the new bot form"

    When "I fill in the new bot form"
    Then "I am shown a list of my bots"
    And "The list includes the bot I just created"
  end
end