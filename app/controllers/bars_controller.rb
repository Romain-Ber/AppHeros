class BarsController < ApplicationController
  def index
    if params[:q] == "proximity"
      @bars = Bar.near([current_user.latitude, current_user.longitude], 1).first(5)
    elsif params[:q] == "max_players"
      @bars = Bar.all.select { |bar| bar.player_count >= 10 }.sort_by(&:player_count).reverse
    elsif params[:q] == "min_players"
      @bars = Bar.all.select { |bar| bar.player_count <= 5 }.sort_by(&:player_count)
    elsif params[:query]
      @bars = Bar.where("name ILIKE ?", "%#{params[:query]}%")
    else
      @bars = Bar.all
    end
    @markers = @bars.geocoded.map do |bar|
      {
        lat: bar.latitude,
        lng: bar.longitude
      }
    end
  end

  def show
    @bar = Bar.find(params[:id])
    @users = User.all
    @users_with_scores = @users.select('users.id, SUM(scores.score) AS total_score')
      .joins(:scores)
      .where('scores.bar_id = ?', @bar.id)
      .group('users.id')
      .order('total_score DESC')
      .limit(3)
    @user1 = User.find(@users_with_scores[0].id)
    @user2 = User.find(@users_with_scores[1].id)
    @user3 = User.find(@users_with_scores[2].id)

    @admin = @users.find_by(email: "admin@gmail.com")
    @admin.update(nearest_bar_id: @bar.id) if @admin
    @romain = @users.find_by(email: "romain@gmail.com")
    @romain.update(nearest_bar_id: @bar.id) if @romain
  end
end
