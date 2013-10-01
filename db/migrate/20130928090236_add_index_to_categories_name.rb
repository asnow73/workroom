class AddIndexToCategoriesName < ActiveRecord::Migration
  def change
    add_index :categories, [:name, :section_id], unique: true
  end
end
