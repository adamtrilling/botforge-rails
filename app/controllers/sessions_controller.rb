class SessionsController < ApplicationController
  skip_before_filter :check_session_token

  def new
    if (check_session_token)
      redirect_to root_path
    end
  end
end