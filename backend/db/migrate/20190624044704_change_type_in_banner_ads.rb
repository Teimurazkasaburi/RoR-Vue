class ChangeTypeInBannerAds < ActiveRecord::Migration[5.2]
  def up
    rename_column :banner_ads, :type, :banner_type
  end
 
  def down
    rename_column :banner_ads, :banner_type, :type
  end
end
