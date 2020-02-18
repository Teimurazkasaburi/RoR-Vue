class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.datetime :time
      t.integer :user_id

      t.timestamps
    end
    add_index :logs, :user_id
  end
end
