class Word < ApplicationRecord
  belongs_to :player

  validates :word, format: { with: /\A[a-zA-Z]+\z/, message: "Only letters are allowed." }
  validates :word, presence: true, length: { minimum: 2, message: "Word must be at least 2 characters long" }

  after_initialize :set_defaults

  attr_reader :double_word, :triple_word

  def set_defaults
    self.double_letter = Array.new() if self.double_letter.nil?
    self.triple_letter = Array.new() if self.triple_letter.nil?
  end
end
