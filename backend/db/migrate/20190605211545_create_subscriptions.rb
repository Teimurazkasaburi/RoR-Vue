class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.string :plan, default: "FREE"
      t.integer :amount, default: 0
      t.datetime :expiring_date
      t.datetime :start_date
      t.integer :boost, default: 0
      t.integer :priorities, default: 0
      t.integer :user_id
      t.timestamps
    end
    add_index :subscriptions, :user_id
  end
end
