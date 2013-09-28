class AddIndexToSectionsName < ActiveRecord::Migration
  def change
    add_index :sections, :name, unique: true
  end
end
