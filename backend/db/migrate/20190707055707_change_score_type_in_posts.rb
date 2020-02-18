class ChangeScoreTypeInPosts < ActiveRecord::Migration[5.2]
  def change
    change_column :posts, :score, :decimal, default: 0.0
  end
end