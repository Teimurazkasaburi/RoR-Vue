class AddReferenceToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :reference_id, :string
    add_index :posts, :reference_id
  end
end
