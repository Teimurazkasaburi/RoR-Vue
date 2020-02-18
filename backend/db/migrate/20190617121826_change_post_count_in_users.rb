class ChangePostCountInUsers < ActiveRecord::Migration[5.2]
  def up
    rename_column :users, :post_count, :posts_count
  end
 
  def down
    rename_column :users, :posts_count, :post_count
  end
end
