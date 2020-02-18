class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :ref_no
      t.integer :amount, default: 0
      t.string :transaction_for
      t.integer :user_id
      t.integer :duration, default: 1
      t.string :status, default: "PENDING"

      t.timestamps
    end
    add_index :transactions, :ref_no
    add_index :transactions, :user_id
  end
end
