class AddColumnPublishedToLinks < ActiveRecord::Migration
  def change
    add_column :links, :published, :boolean, :default => true

    Link.reset_column_information
    reversible do |dir|
      dir.up { Link.update_all published: true }
    end
  end
end
