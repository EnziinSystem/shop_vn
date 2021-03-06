class CreateOrderItems < ActiveRecord::Migration[5.1]
  def change
    create_table :order_items do |t|
      t.references :product, foreign_key: true
      t.integer :quantity, default: 1
      t.references :cart, foreign_key: true
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
