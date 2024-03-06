class Bar < ApplicationRecord
  has_many :challenges
  has_many :scores
  has_many :users
  validates :name, :description, :address, presence: true
end
