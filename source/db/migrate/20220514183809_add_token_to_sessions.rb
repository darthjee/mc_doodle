# frozen_string_literal: true

class AddTokenToSessions < ActiveRecord::Migration[5.2]
  def change
    change_table :sessions do |t|
      t.string :token, limit: 64, null: false

      t.index :token, unique: true
    end
  end
end
