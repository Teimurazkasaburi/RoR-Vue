class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :f_name
      t.string :l_name
      t.string :username, null: false, index: true, unique: true
      t.string :email, null: false, index: true, unique: true
      t.string :password_digest

      t.timestamps
    end
  end
end
