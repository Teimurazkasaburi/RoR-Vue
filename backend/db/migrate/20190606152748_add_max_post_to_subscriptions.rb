class AddMaxPostToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :max_post, :integer, default: 3
  end
end
