class MatchesController < ApplicationController
  def show
    begin
      @match = Match.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render nothing: true, status: 404 and return
    end
  end

  def create
    unless Match::GAMES.has_key?(params[:game])
      redirect_to games_path and return
    end

    @game = params[:game]
    @match = @game.constantize.new
    @match.participants.build(
      player: current_user.human_for(@game)
    )

    @match.start_match
    @match.request_move

    redirect_to match_path(@match)
  end
end