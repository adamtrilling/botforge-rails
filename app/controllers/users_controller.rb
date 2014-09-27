class UsersController < ApplicationController
  skip_before_filter :check_session_token

  def new
    if (check_session_token)
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(registration_params)

    if (@user.save)
      redirect_to root_path
    else
      render :new
    end
  end

  private
  def registration_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end