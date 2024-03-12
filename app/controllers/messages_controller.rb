class MessagesController < ApplicationController
  def create
    @challenge = Challenge.find(params[:challenge_id])
    @message = Message.new(message_params)
    @message.challenge = @challenge
    @message.user = current_user
    if @message.save
      redirect_to challenge_path(@challenge)
    else
      render "challenges/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
