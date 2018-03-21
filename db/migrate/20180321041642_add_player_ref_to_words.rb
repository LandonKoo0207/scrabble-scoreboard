class AddPlayerRefToWords < ActiveRecord::Migration[5.1]
  def change
    add_reference :words, :player, foreign_key: true
  end
end
