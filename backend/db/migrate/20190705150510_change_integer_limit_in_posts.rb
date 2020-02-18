class ChangeIntegerLimitInPosts < ActiveRecord::Migration[5.2]
  def change
    change_column :posts, :price, :integer, limit: 8
  end
end
