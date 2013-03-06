class CreateMusics < ActiveRecord::Migration
  def change
    create_table :musics do |t|
      t.string :name
      t.integer :played_times, :default => 0
      t.string :artist

      t.timestamps
    end
  end
end
