class AddTurnToWord < ActiveRecord::Migration[5.1]
  def change
    add_column :words, :turn, :integer
  end
end
