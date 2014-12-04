class BotsController < ApplicationController
  def index
    authorize! :list, Bot
    @bots = current_user.bots
  end

  def new
    authorize! :create, Bot
    @bot = Bot.new(user: current_user)
  end
end