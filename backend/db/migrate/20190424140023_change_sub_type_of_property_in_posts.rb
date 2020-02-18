class ChangeSubTypeOfPropertyInPosts < ActiveRecord::Migration[5.2]
  def up
    rename_column :posts, :sub_type_of_property, :type_of_property
  end
 
  def down
    rename_column :posts, :type_of_property, :sub_type_of_property
  end
end
