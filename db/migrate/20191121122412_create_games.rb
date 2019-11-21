class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.text :visible_board, array:true, default: []
      t.text :mine_board, array:true, default: []
      t.boolean :game_lost, default: false

      t.timestamps
    end
  end
end
