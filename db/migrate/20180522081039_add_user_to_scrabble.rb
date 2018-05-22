class AddUserToScrabble < ActiveRecord::Migration[5.1]
  def change
    add_reference :scrabbles, :user, foreign_key: true
  end
end
