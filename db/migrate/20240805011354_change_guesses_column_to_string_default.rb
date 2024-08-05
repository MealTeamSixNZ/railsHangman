class ChangeGuessesColumnToStringDefault < ActiveRecord::Migration[7.1]
  def change
    change_column :games, :guesses, :string, default: ""
  end
end
