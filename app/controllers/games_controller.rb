class GamesController < ApplicationController
  def index
  end

  def show
    unless (Match::GAMES.has_key?(params[:id]))
      render status: 404
    end
  end
end