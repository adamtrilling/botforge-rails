require 'rails_helper'

feature "User management" do
  scenario "login" do
    Given "I have an account"
    And "I am at the login page"

    When "I log in with my username and password"
    Then "I am shown to be logged in"
  end

  scenario "account registration" do
    Given "I am at the login page"
    When "I elect to create an account"
    Then "I am shown the registration page"

    When "I fill in the registration page"
    Then "I get a confirmation email"

    When "I click the confirmation link"
    Then "I am shown to be logged in"
    And "My account is shown to be confirmed"

    When "I log out"
    And "I log in with my username and password"
    Then "I am shown to be logged in"
  end
end