class AddViewCountToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :view_count, :integer, default: 0
  end
end
