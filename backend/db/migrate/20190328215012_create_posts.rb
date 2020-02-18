class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :price
      t.string :duration
      t.string :description
      t.string :title
      t.string :purpose
      t.string :use_of_property
      t.string :sub_type_of_property
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :toliets
      t.string :video_link
      t.string :street
      t.string :lga
      t.string :state
      t.string :permalink, index: true

      t.timestamps
    end
  end
end
