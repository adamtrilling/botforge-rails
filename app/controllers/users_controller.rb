class UsersController < ApplicationController
  def new
    if (current_user)
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(registration_params)
    token = @user.set_confirmation_token

    if (@user.save)
      UserMailer.confirmation(@user, token).deliver_now
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

      session[:user_id] = @user.id
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