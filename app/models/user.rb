class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :challenges
  has_many :messages
  has_many :scores

  def near_bars
    bars = Bar.all.select do |bar|
      Geocoder::Calculations.distance_between([self.latitude, self.longitude], [bar.latitude, bar.longitude]) < 1
    end
    bars.map do |bar|
      bar.id
    end
  end
end
