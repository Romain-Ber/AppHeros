class BarsmapController < ApplicationController
  def index
    @bars = Bar.all
    @markers = @bars.geocoded.map do |bar|
      {
        lat: bar.latitude,
        lng: bar.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { bar: bar })
      }
    end
  end
end
