class BotsController < ApplicationController
  def index
    authorize! :list, Bot
    @bots = current_user.bots
  end

  def new
    authorize! :create, Bot
    @bot = Bot.new(user: current_user)
  end

  def create
    authorize! :create, Bot
    @bot = Bot.new(create_params)

    if (@bot.save)
      redirect_to bots_path
    else
      render :new
    end
  end

  private
  def create_params
    params.require(:bot).permit(
      :name, :url, :game, :active
    ).merge(
      user_id: current_user.id
    )
  end
end