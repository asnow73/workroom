class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :url
      t.text :description
      t.integer :category_id

      t.timestamps
    end
    add_index :links, [:category_id, :created_at]
  end
end
