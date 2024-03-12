class ChallengeChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    challenge = Challenge.find(params[:id])
    stream_for challenge
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
