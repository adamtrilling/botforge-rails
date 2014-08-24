require 'rails_helper'

feature "Forum" do
  scenario "View a thread" do
    Given "I am logged in"
    And "There are forum groups with posts"
    
    When "I visit the group"
    Then "I see a list of threads"
    When "I click on a thread"
    Then "I see the posts"
  end

  scenario "Reply to a post" do
    Given "I am logged in"
    And "There are forum groups with posts"

    When "I visit a thread"
    Then "I can reply to the thread"
    When "I enter my reply"
    Then "I see the reply"
  end

  scenario "Create a thread" do
    Given "I am logged in"
    And "There are forum groups with posts"

    When "I visit the group"
    Then "I can create a thread"
    When "I enter the thread title and first post"
    Then "I see the thread"
  end
end