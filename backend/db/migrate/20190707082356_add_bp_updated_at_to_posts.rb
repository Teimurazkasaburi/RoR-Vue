class AddBpUpdatedAtToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :promotion_updated_at, :datetime
  end
end
