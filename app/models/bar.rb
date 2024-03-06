class Bar < ApplicationRecord
  has_many :challenges
  has_many :scores
  validates :name, :description, :address, presence: true
end
