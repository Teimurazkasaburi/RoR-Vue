class AddSquareMetersToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :square_meters, :string
  end
end
