class CreateBannerAds < ActiveRecord::Migration[5.2]
  def change
    create_table :banner_ads do |t|
      t.string :ref_no
      t.string :status, default: "INACTIVE"
      t.datetime :expiring_date
      t.string :url
      t.string :type
      t.integer :duration

      t.timestamps
    end
  end
end
