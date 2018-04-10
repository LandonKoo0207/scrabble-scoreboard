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
                              'W':2,'X':1,'Y':2,'Z':1} \
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
end
