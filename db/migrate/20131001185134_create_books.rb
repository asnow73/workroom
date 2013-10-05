class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :name
      t.text :description
      t.string :image_url
      t.string :source_url
      t.integer :category_id

      t.timestamps
    end
  end
end
