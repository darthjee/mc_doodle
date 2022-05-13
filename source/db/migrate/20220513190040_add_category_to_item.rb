class AddCategoryToItem < ActiveRecord::Migration[5.2]
  def change
    change_table :move_items do |t|
      t.bigint :category_id, null: false

      t.foreign_key :move_categories, column: :category_id
    end
  end
end
