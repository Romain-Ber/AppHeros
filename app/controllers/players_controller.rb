class PlayersController < ApplicationController
  before_action :set_bar, only: %i[index]
  def index
    @users = User.where(nearest_bar_id: @bar).where.not(id: current_user.id)
  end

  private

  def set_bar
    @bar = Bar.find(params[:bar_id])
  end
end
