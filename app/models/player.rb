class Player < ApplicationRecord
  validates_uniqueness_of :turn
  validates :turn, inclusion: { in: 1..4 }

  has_many :words
  belongs_to :scrabble
end
