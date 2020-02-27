class CreateMentions < ActiveRecord::Migration[6.0]
  def change
    create_table :mentions do |t|
      t.integer :user_id
      t.integer :micropost_id

      t.timestamps
    end
    add_index :mentions, :user_id
    add_index :mentions, :micropost_id
    add_index :mentions, [:user_id, :micropost_id], unique: true
  end
end
