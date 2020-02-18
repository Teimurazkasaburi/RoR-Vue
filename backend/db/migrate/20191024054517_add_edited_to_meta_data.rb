class AddEditedToMetaData < ActiveRecord::Migration[5.2]
  def change
    add_column :meta_data, :edited, :boolean, default: false
  end
end
