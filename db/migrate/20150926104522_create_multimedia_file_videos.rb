class CreateMultimediaFileVideos < ActiveRecord::Migration
  def change
    create_table :multimedia_file_videos do |t|
      t.string :title
      t.text :description
      t.string :provider
      t.string :url
      t.integer :owner_id
      t.integer :album_id

      t.timestamps null: false
    end
  end
end
