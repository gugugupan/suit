class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :user_id
      t.integer :music_id
      t.float :score, :default => 0.5

      t.timestamps
    end
  end
end
