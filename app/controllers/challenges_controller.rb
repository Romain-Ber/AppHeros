class ChallengesController < ApplicationController

  def update_winner
    @challenge = Challenge.find(params[:id])

    @challenge.winner = User.find(params[:winner_id])

    # Définir le perdant
    # @challenge.loser = User.find(...)

    # Définir les scores

    @challenge.save

    # MEGA OPTIONNEL - NE PAS FAIRE TOUT DE SUITE
    # Diffuser un évenement pour infiormer le perdant
  end

  def show
    @challenge = Challenge.find(params[:id])
    @message = Message.new
    @bar = Bar.find(@challenge.bar_id)
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

    if @challenge.save

      ChallengeChannel.broadcast_to(
        @challenged,
        render_to_string(partial: "players/invitation", locals: { challenge: @challenge })
      )

      redirect_to challenge_path(@challenge)
    end
  end
end
