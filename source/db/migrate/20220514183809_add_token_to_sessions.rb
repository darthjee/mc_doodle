class AddTokenToSessions < ActiveRecord::Migration[5.2]
  def change
    change_table :sessions do |t|
      t.string :token, limit: 64

      t.index :token, unique: true
    end
  end
end
