class CreateMetaData < ActiveRecord::Migration[5.2]
  def change
    create_table :meta_data do |t|
      t.references :post, foreign_key: true, index: true
      t.string :site
      t.string :title
      t.string :description
      t.string :keywords
      t.string :charset
      t.boolean :reverse
      t.boolean :noindex
      t.boolean :nofollow
      t.boolean :noarchive
      t.string :canonical
      t.string :image_src
      t.string :og_title
      t.string :og_type
      t.string :og_url
      t.string :og_image
      t.string :og_video_director
      t.string :og_video_writer
      t.string :twitter_card
      t.string :twitter_site
      t.string :twitter_creator

      t.timestamps
    end
  end
end
