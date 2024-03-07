class Bar < ApplicationRecord
  has_many :challenges
  has_many :scores
  validates :name, :description, :address, presence: true
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
