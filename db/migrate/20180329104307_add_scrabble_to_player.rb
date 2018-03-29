class AddScrabbleToPlayer < ActiveRecord::Migration[5.1]
  def change
    add_reference :players, :scrabble, foreign_key: true
  end
end
