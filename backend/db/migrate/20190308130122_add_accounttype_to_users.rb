class AddAccounttypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :account_type, :string
    add_column :users, :phone, :string
    add_column :users, :address, :jsonb
    add_column :users, :about, :text
    add_column :users, :ucid, :string
    add_column :users, :admin, :boolean, null: false, default: false
  end
end
