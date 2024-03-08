class ResultsController < ApplicationController
  def show
    @challenge = Challenge.find(params[:challenge_id])
  end
end
