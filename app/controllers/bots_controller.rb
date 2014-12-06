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

  def edit
    @bot = Bot.find(params[:id])
    authorize! :update, @bot
  end

  def update
    @bot = Bot.find(params[:id])
    authorize! :update, @bot

    if (@bot.update_attributes(update_params))
      redirect_to bots_path
    else
      render :edit
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

  def update_params
    params.require(:bot).permit(
      :name, :url, :game, :active
    )
  end
end