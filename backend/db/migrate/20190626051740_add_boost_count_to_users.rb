class AddBoostCountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :boost_count, :integer, default: 0
    add_column :users, :priority_count, :integer, default: 0
    add_column :users, :post_requests_count, :integer, default: 0
  end
end
