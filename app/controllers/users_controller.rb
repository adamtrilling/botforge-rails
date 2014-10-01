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
      UserMailer.confirmation(@user, 'abcde').deliver_now
      redirect_to root_path
    else
      render :new
    end
  end

  def confirm
    @user = User.find(params[:id])

    if (@user && @user.verify_confirmation_token(params[:token]))
      @user.confirmation_token = nil
      @user.confirmed_at = Time.now
      @user.save

      redirect_to user_path(@user)
    else
      redirect_to root_path
    end
  end

  def show
    @user = User.find(params[:id])

    unless (@user)
      render nothing: true, status: 404
    end
  end

  private
  def registration_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end