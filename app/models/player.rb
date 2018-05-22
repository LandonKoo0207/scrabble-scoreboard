# frozen_string_literal: true

class Player < ApplicationRecord
  validates :turn, inclusion: { in: 1..4 }
  validates :name, presence: true, length: { minimum: 1, message: "Player's \
                                            name must be entered." }

  has_many :words, dependent: :destroy
  belongs_to :scrabble
end
