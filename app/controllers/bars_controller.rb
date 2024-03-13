class BarsController < ApplicationController
  def index
    @bars = Bar.all
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
  end
end
