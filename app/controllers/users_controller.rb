class UsersController < ApplicationController
  skip_before_filter :check_session_token

  def new
    if (check_session_token)
      redirect_to root_path
    else
      @user = User.new
    end
  end
end