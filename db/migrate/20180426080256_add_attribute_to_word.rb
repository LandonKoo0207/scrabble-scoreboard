class AddAttributeToWord < ActiveRecord::Migration[5.1]
  def change
    add_column :words, :existing_letter, :integer, array: true
  end
end
