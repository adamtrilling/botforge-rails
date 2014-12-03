class BotsController < ApplicationController
  def index
    @bots = current_user.bots
  end

  def new
    @bot = Bot.new(user: current_user)
  end
end