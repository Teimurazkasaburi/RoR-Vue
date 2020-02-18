class CreateVerifyUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :verify_users do |t|
      t.integer :user_id

      t.timestamps
    end
    add_index :verify_users, :user_id
  end
end
