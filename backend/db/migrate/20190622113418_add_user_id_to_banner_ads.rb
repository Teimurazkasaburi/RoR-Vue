class AddUserIdToBannerAds < ActiveRecord::Migration[5.2]
  def change
    add_column :banner_ads, :user_id, :integer
    add_index :banner_ads, :user_id
    add_index :banner_ads, :ref_no
  end
end
