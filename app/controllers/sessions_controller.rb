class SessionsController < ApplicationController
  def new
    redirect_to root_path if (current_user)
  end

  def create
    if (current_user)
      redirect_to root_path
    else
      @user = User.find_by(login: params["username"])

      if (@user && @user.authenticate(params[:password]))
        session[:user_id] = @user.id
        redirect_to root_path
      else
        session[:user_id] = nil
        render :new
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path
  end
end