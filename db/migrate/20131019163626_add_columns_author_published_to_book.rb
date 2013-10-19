class AddColumnsAuthorPublishedToBook < ActiveRecord::Migration
  def change
    add_column :books, :published, :boolean, :default => true
    add_column :books, :author, :string, :default => ""

    Post.reset_column_information
    reversible do |dir|
      dir.up do
        Book.update_all published: true
        Book.update_all author: "неизвестен"
      end
    end

  end
end
