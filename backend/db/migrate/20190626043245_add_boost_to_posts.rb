class AddBoostToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :boost, :integer, default: 0
    add_column :posts, :priority, :integer, default: 0
    add_column :posts, :score, :integer, default: 0
  end
end
