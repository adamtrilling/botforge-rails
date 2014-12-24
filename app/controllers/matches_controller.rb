class MatchesController < ApplicationController
  def create
    unless Match::GAMES.has_key?(params[:game])
      redirect_to games_path and return
    end

    @game = params[:game]
    @match = @game.constantize.new

    redirect_to match_path(@match)
  end
end