class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.text :body
      t.string :owner
      t.integer :user_id

      t.timestamps
    end
    add_index :contacts, :owner
    add_index :contacts, :user_id
  end
end
