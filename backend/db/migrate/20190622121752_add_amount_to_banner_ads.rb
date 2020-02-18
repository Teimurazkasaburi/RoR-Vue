class AddAmountToBannerAds < ActiveRecord::Migration[5.2]
  def change
    add_column :banner_ads, :amount, :integer, default: 0
  end
end
