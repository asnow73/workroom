class AddIndexToBookName < ActiveRecord::Migration
  def change
    add_index :books, [:name, :category_id], unique: true
  end
end
