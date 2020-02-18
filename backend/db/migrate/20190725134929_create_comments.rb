class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :user_id
      t.integer :forum_id

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :forum_id
  end
end
