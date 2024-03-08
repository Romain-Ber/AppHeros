class GamesController < ApplicationController
  def show
    @challenge = Challenge.find(params[:challenge_id])
    @game = @challenge.game.slug
    @sender = @challenge.challenger
    @receiver = @challenge.challenged
    @winner_score = @challenge.winner_score
    @loser_score = @challenge.loser_score
  end
end
