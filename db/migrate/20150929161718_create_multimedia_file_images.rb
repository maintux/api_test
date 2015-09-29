class CreateMultimediaFileImages < ActiveRecord::Migration
  def change
    create_table :multimedia_file_images do |t|
      t.string :title
      t.text :description
      t.attachment :attachment
      t.integer :owner_id
      t.integer :album_id

      t.timestamps null: false
    end
  end
end
