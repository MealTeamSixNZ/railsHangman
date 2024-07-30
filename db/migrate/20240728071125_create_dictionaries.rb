class CreateDictionaries < ActiveRecord::Migration[7.1]
  def change
    create_table :dictionaries do |t|
      t.string :word
      t.integer :difficulty

      t.timestamps
    end
  end
end
