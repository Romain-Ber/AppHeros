class PlayersController < ApplicationController
  before_action :set_bar, only: %i[index]
  def index
    @users = User.all.where(nearest_bar_id: @bar)
  end

  private

  def set_bar
    @bar = Bar.find(params[:bar_id])
  end
end
