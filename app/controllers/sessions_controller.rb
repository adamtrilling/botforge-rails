class SessionsController < ApplicationController
  def new
    if (current_user)
      redirect_to root_path
    end
  end
end