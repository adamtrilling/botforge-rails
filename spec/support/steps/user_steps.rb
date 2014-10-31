module Features
  module Steps
    def i_am_logged_in
      visit new_session_path

      fill_in 'Username', with: current_user.username
      fill_in 'Password', with: current_user.password

      click_button 'Log in'
    end
  end
end