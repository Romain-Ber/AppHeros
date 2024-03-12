class ChallengesController < ApplicationController

  def show
    @challenge = Challenge.find(params[:id])
    @message = Message.new

    @game = @challenge.game.slug
    @sender = @challenge.challenger
    @receiver = @challenge.challenged
    @winner_score = @challenge.winner_score
    @loser_score = @challenge.loser_score
  end

  def create
    @bar = Bar.find(params[:bar_id])
    @challenger = current_user
    @challenged = User.find(params[:challenged_id])
    @game = Game.find_by(slug: params[:game_slug])
    @challenge = Challenge.new(
      bar: @bar,
      challenger: @challenger,
      challenged: @challenged,
      location: "",
      status: "ongoing",
      game: @game
    )
    if @challenge.save!
      redirect_to challenge_path(@challenge)
    end
  end
end
