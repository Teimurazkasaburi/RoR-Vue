class AddPermalinkToForums < ActiveRecord::Migration[5.2]
  def change
    add_column :forums, :permalink, :string
    add_index :forums, :permalink

  end
end
