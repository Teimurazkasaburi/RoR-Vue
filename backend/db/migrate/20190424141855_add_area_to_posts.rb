class AddAreaToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :area, :string
  end
end
