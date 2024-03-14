class BarsmapController < ApplicationController
  def index
    @bars = Bar.all
    @markers = @bars.geocoded.map do |bar|
      {
        lat: bar.latitude,
        lng: bar.longitude
      }
    end
  end
end
