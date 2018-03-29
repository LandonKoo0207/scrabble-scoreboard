class Word < ApplicationRecord
  belongs_to :player

  validates :word, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }

  after_initialize :set_defaults

  attr_reader :double_word, :triple_word

  def set_defaults
    self.double_letter = Array.new() if self.double_letter.nil?
    self.triple_letter = Array.new() if self.triple_letter.nil?
  end
end
