class CreateWords < ActiveRecord::Migration[5.1]
  def change
    create_table :words do |t|
      t.string :word
      t.integer :double_letter, array: true
      t.integer :triple_letter, array: true
      t.boolean :double_word
      t.boolean :triple_word
      t.integer :score

      t.timestamps
    end
  end
end
