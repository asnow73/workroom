class AddIndexToLinksUrl < ActiveRecord::Migration
  def change
    add_index :links, [:url, :category_id], unique: true
    # add_index :links, :url, unique: true

  end
end
