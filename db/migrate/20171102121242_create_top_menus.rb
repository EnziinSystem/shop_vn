class CreateTopMenus < ActiveRecord::Migration[5.1]
  def change
    create_table :top_menus do |t|
      t.string :title
      t.string :link
      t.string :icon
      t.integer :tag
      t.boolean :published

      t.timestamps
    end
  end
end
