class Word < ApplicationRecord
  belongs_to :player

  validates :word, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }

  attr_reader :double_word, :triple_word
end
