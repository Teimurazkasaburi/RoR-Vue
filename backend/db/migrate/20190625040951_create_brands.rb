class CreateBrands < ActiveRecord::Migration[5.2]
  def change
    create_table :brands do |t|
      t.string :ref_no
      t.string :status, default: "INACTIVE"
      t.string :url
      t.datetime :expiring_date
      t.integer :duration, default: 1
      t.integer :user_id
      t.string :amount, default: 0

      t.timestamps
    end
    add_index :brands, :ref_no
    add_index :brands, :user_id
  end
end
