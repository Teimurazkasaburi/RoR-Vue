class AddUnpublishToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :unpublish, :boolean, null: false, default: false
  end
end