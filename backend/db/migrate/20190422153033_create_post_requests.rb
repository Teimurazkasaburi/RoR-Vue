class CreatePostRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :post_requests do |t|
      t.string :purpose
      t.integer :budget
      t.string :type_of_property
      t.string :state
      t.string :lga
      t.string :area
      t.text :description
      t.integer :user_id, index: true

      t.timestamps
    end
  end
end
