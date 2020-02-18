class CreateMarkers < ActiveRecord::Migration[5.2]
  def change
    create_table :markers do |t|
      t.boolean :saved, null: false, default: false
      t.integer :user_id
      t.integer :post_id
      t.string :type_of_maker

      t.timestamps
    end
    add_index :markers, :post_id
    add_index :markers, :user_id
  end
end
