class AddLastLoggedInToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :last_logged_in, :datetime
  end
end
