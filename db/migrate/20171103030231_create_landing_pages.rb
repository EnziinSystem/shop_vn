class CreateLandingPages < ActiveRecord::Migration[5.1]
  def change
    create_table :landing_pages do |t|
      t.string :title
      t.references :product, foreign_key: true
      t.text :content, :limit => 16777215

      t.timestamps
    end
  end
end
