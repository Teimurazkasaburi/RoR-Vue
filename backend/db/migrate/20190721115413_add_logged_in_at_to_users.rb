class AddLoggedInAtToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :logged_in_at, :datetime
  end
end
