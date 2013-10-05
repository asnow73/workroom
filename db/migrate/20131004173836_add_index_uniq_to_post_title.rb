class AddIndexUniqToPostTitle < ActiveRecord::Migration
  def change
    add_index :posts, [:title, :category_id], unique: true
  end
end
