class GamesController < ApplicationController
  def show
    @challenge = Challenge.first
    @game = @challenge.game.slug
    @sender = @challenge.challenger
    @receiver = @challenge.challenged
  end
end
