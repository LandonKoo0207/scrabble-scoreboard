class Scrabble < ApplicationRecord
  has_many :players, dependent: :destroy

  serialize :remaining_letters, Hash

  validates :num_of_players, presence: true, inclusion: { in: 2..4, message: "The number of players must be between 2 and 4." }

  after_initialize :set_defaults

  default_scope { order(:id) }

  def set_defaults
    self.current_turn = 1 if self.current_turn.nil?
    self.remaining_letters = {'A':9, 'B':2, 'C':2, 'D':4, 'E':12, 'F':2, 'G':3, \
                              'H':2, 'I':9, 'J':1, 'K':1, 'L':4, 'M':2, 'N':6, \
                              'O':8, 'P':2, 'Q':1,'R':6,'S':4,'T':6,'U':4,'V':2, \
                              'W':2, 'X':1,'Y':2,'Z':1} \
                              if self.remaining_letters.length == 0
  end

  def set_current_player(player_id)
    if self.players.last.id == player_id
      self[:current_player] = self.players.first.id
      self[:current_turn] += 1
    else
      self[:current_player] += 1
    end
  end

  def word_possible(word, existing_letter)
    word_in_hash = new_letters_in_hash(word, existing_letter)
    word_in_hash.each do |letter, count|
      if count > self.remaining_letters[letter.upcase.to_sym]
        return false
      end
    end
    true
  end

  def existing_letters_to_ints(existing_letter)
    if existing_letter.nil?
      Array.new
    else
      existing_letter.map(&:to_i)
    end
  end

  def take_letter(letter)
    self.remaining_letters[letter.upcase.to_sym] -= 1
  end

  def put_back_letter(letter)
    self.remaining_letters[letter.upcase.to_sym] += 1
  end

  def take_letters_for_word(old_word, old_existing_letter, new_word, new_existing_letter)
    old_word = "" if old_word.nil?
    old_existing_letter = existing_letters_to_ints(old_existing_letter)
    new_existing_letter = existing_letters_to_ints(new_existing_letter)
    
    new_word.each_char.with_index do |char, index|
      if old_word[index] != new_word[index]
        if new_existing_letter.exclude? index
          take_letter(char)
        end
      else
        if new_existing_letter.exclude? index
          take_letter(char)
        end
      end
    end
  end

  def put_back_word(old_word, old_existing_letter, new_word, new_existing_letter)
    old_existing_letter = existing_letters_to_ints(old_existing_letter)
    new_existing_letter = existing_letters_to_ints(new_existing_letter)

    old_word.each_char.with_index do |char, index|
      if old_word[index] != new_word[index]
        if new_existing_letter.exclude? index
          put_back_letter(char)
        end
      else
        put_back_letter(char) if old_existing_letter.exclude? index
      end
    end
  end

  def new_letters_in_hash(word, existing_letter)
    new_letters_in_word = ""
    if !existing_letter.nil? 
      for i in (0..word.length-1)
        new_letters_in_word += word[i] if existing_letter.exclude? i
      end
    else
      new_letters_in_word = word
    end
    Hash[new_letters_in_word.split('').group_by{ |c| c }.map{ |key, value| [key, value.size] }]
  end
end
