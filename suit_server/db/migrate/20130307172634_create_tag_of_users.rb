class CreateTagOfUsers < ActiveRecord::Migration
  def change
    create_table :tag_of_users do |t|
      t.integer :tag_id
      t.integer :user_id

      t.timestamps
    end
  end
end
