class ChangeCommentsCountInForum < ActiveRecord::Migration[5.2]
  def change
    change_column :forums, :comments_count, :integer, default: 0
  end
end
