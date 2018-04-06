class AddRemainingLettersToScrabble < ActiveRecord::Migration[5.1]
  def change
    add_column :scrabbles, :remaining_letters, :string
  end
end
