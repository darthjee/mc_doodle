# frozen_string_literal: true

class CreateMoveItems < ActiveRecord::Migration[5.2]
  def change
    create_table :move_items do |t|
      t.bigint :move_id, null: false
      t.string :name, null: false

      t.timestamps

      t.foreign_key :moves
    end
  end
end
