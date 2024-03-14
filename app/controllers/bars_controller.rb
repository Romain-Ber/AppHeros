class BarsController < ApplicationController
  def index
    if params[:q] == "proximity"
      @bars = Bar.near([current_user.latitude, current_user.longitude], 1).first(5)
    elsif params[:q] == "max_players"
      @bars = Bar.all.select { |bar| bar.player_count >= 10 }.sort_by(&:player_count).reverse.first(20)
    elsif params[:q] == "min_players"
      @bars = Bar.all.select { |bar| bar.player_count <= 5 }.sort_by(&:player_count).first(18)
    elsif params[:query]
      @bars = Bar.where("name ILIKE ?", "%#{params[:query]}%")
    else
      @bars = Bar.all.first(50)
    end
  end

  def show
    @bar = Bar.find(params[:id])
    @users = User.where(nearest_bar_id: @bar.id)
    @users = @users.sort_by(&:score).reverse
    if @users.count >= 3
      @player1 = @users[0]
      @player2 = @users[1]
      @player3 = @users[2]
    elsif @users.count == 2
      @player1 = @users[0]
      @player2 = @users[1]
      @player3 = nil
    elsif @users.count == 1
      @player1 = @users[0]
      @player2 = nil
      @player3 = nil
    else
      @player1 = nil
      @player2 = nil
      @player3 = nil
    end
    current_user.update(nearest_bar_id: @bar.id)
  end
end
