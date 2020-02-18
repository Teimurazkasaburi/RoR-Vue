class ChangeBathroomsInPostRequests < ActiveRecord::Migration[5.2]
  def up
    rename_column :post_requests, :bathrooms, :bedrooms
  end
 
  def down
    rename_column :post_requests, :bedrooms, :bathrooms
  end
end
