class AddPostCountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :post_count, :integer, default: 0
  end
end
