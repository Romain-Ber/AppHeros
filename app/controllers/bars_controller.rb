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
  end
end
