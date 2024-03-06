class BarPlayersController < ApplicationController
  def index
    @users = Bar.find(params[:id]).users
  end
end
