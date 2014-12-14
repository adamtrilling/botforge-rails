class GamesController < ApplicationController
  def index
  end

  def show
    if (Match::GAMES.has_key?(params[:id]))
      @game = params[:id]
      @game_attrs = Match::GAMES[params[:id]]
    else
      render status: 404
    end
  end
end