class AddColumnPublishedToPost < ActiveRecord::Migration
  def change
    add_column :posts, :published, :boolean, :default => true

    Post.reset_column_information
    reversible do |dir|
      dir.up { Post.update_all published: true }
    end
  end
end
