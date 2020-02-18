class ChangeDurationDefaultInBannerAds < ActiveRecord::Migration[5.2]

  def up
    change_column :banner_ads, :duration, :integer, default: 1
  end
  
  def down
    change_column :banner_ads, :duration, :integer, default: nil
  end

end
