class CreateScrabbles < ActiveRecord::Migration[5.1]
  def change
    create_table :scrabbles do |t|
      t.integer :num_of_players
      t.integer :current_turn
      t.integer :current_player

      t.timestamps
    end
  end
end
