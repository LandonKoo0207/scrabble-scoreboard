class Scrabble < ApplicationRecord
  has_many :players, dependent: :destroy

  after_initialize :set_defaults

  def set_defaults
    self.current_turn = 1 if self.current_turn.nil?
  end
end
