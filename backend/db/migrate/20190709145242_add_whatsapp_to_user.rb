class AddWhatsappToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :whatsapp, :string
    add_column :users, :country_code_whatsapp, :string
    add_column :users, :verified, :boolean, null: false, default: false
  end
end
