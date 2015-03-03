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
    
    When "I log out"
    And "I log in with my email and password"
    Then "I am shown to be logged in"
  end

  let(:name) { Faker::Name.name }
  let(:email) { Faker::Internet.email }
  let(:password) { 'password1' }

  let(:user) { FactoryGirl.create(:user, password: password) }

  def i_am_at_the_login_page
    visit new_session_path
  end

  def i_elect_to_create_an_account
    within '#content' do
      click_link "Register"
    end
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

    click_button 'Register'
  end

  def i_get_a_confirmation_email
    open_email(email)
  end

  def i_click_the_confirmation_link
    current_email.click_link 'confirm your account'
  end

  def i_am_shown_to_be_logged_in
    within '#header' do
      expect(page).to have_text(name)
    end
  end

  def i_log_out
    click_link 'Log out'
  end

  def i_log_in_with_my_email_and_password
    visit new_session_path

    fill_in 'Username', with: email
    fill_in 'Password', with: password

    click_button 'Log in'
  end
end