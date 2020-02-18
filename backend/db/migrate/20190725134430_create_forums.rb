class CreateForums < ActiveRecord::Migration[5.2]
  def change
    create_table :forums do |t|
      t.string :subject
      t.string :category
      t.text :body
      t.integer :comments_count
      t.integer :user_id

      t.timestamps
    end
    add_index :forums, :user_id
    add_index :forums, :subject
  end
end
