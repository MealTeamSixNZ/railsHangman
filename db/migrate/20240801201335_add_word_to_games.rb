class AddWordToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :gameword, :string
  end
end
