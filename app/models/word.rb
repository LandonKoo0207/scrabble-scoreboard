# frozen_string_literal: true

class Word < ApplicationRecord
  belongs_to :player

  validates :word, format: { with: /\A[a-zA-Z]+\z/, message: 'Only letters are allowed.' }, unless: :skip_validations
  validates :word, presence: true, length: { minimum: 2, message: 'Word must be at least 2 
                                           characters long.' }, unless: :skip_validations
  validates_presence_of :existing_letter, message: "At least 1 \"Alreay Exists?\" letter must be checked.\n \
                                          A new word cannot be created on its own unless it's the \
                                          first word of the scrabble game", \
                                          unless: :first_turn_of_first_player

  after_initialize :set_defaults
  before_save :calculate_score

  default_scope { order(:id) }

  attr_reader :double_word, :triple_word
  attr_accessor :skip_validations

  def set_defaults
    self.double_letter = [] if double_letter.nil?
    self.triple_letter = [] if triple_letter.nil?
    self.score = 0 if score.nil?
    self.existing_letter = [] if existing_letter.nil?
  end

  def first_turn_of_first_player
    current_player = Player.find(player_id)
    current_scrabble = Scrabble.find(current_player.scrabble_id)

    (current_player == current_scrabble.players.first && current_scrabble.current_turn == 1) || skip_validations
  end

  def calculate_score
    score = { 'A': 1, 'B': 3, 'C': 3, 'D': 2, 'E': 1, 'F': 4, 'G': 2, 'H': 4, 'I': 1, 'J': 8, \
              'K': 5, 'L': 1, 'M': 3, 'N': 1, 'O': 1, 'P': 3, 'Q': 10, 'R': 1, 'S': 1, 'T': 1, \
              'U': 1, 'V': 4, 'W': 4, 'X': 8, 'Y': 4, 'Z': 10 }
    s = 0
    self[:word].each_char.with_index do |char, i|
      s += if self[:double_letter].include? i + 1
             score[char.upcase.to_sym] * 2
           elsif self[:triple_letter].include? i + 1
             score[char.upcase.to_sym] * 3
           else
             score[char.upcase.to_sym]
           end
    end

    s *= 2 if self[:double_word]
    s *= 3 if self[:triple_word]

    self[:score] = s
  end
end
