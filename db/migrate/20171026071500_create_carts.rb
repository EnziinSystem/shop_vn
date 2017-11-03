class CreateCarts < ActiveRecord::Migration[5.1]
  def change
    create_table :carts do |t|
      t.string :token_key
      t.string :email
      t.string :tag

      t.timestamps
    end
  end
end
