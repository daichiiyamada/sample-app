class AddReplyingToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :replying, :boolean
  end
end
