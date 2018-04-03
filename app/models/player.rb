class Player < ApplicationRecord
  validates :turn, inclusion: { in: 1..4 }

  has_many :words, dependent: :destroy
  belongs_to :scrabble
end
