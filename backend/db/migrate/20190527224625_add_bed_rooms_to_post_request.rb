class AddBedRoomsToPostRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :post_requests, :bathrooms, :integer
  end
end
