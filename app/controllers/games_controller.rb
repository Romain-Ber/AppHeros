class GamesController < ApplicationController
  def show
    @challenge = Challenge.first
    @game = @challenge.game.slug
    @sender = @challenge.from
    @receiver = @challenge.to
  end
end
