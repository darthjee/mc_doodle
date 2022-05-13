class CreateMoves < ActiveRecord::Migration[5.2]
  def change
    create_table :moves do |t|
      t.bigint :user_id, null: false
      t.string :title, null: false
      t.timestamps
    end
  end
end
