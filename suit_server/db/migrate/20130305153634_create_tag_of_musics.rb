class CreateTagOfMusics < ActiveRecord::Migration
  def change
    create_table :tag_of_musics do |t|
      t.integer :music_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
