require 'rails_helper'

feature "User management" do
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

  scenario "login" do
    Given "I have an account"
    And "I am at the login page"

    When "I log in with my username and password"
    Then "I am shown to be logged in"
  end

  let(:name) { Faker::Name.name }
  let(:email) { Faker::Internet.email }
  let(:password) { 'password1' }

  def i_am_at_the_login_page
    visit new_session_path
  end

  def i_elect_to_create_an_account
    click_link "Register"
  end

  def i_am_shown_the_registration_page
    expect(page).to have_field "Username"
    expect(page).to have_field "Email"
    expect(page).to have_field "Password"
    expect(page).to have_field "Confirm password"
  end

  def i_fill_in_the_registration_page
    fill_in 'Username', with: name
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Confirm password', with: password

    click_button 'Create User'
  end
end