class ChangeDatatypeIdOfNotifications < ActiveRecord::Migration[5.2]
  def change
    change_column :notifications, :post_id, :integer
    change_column :notifications, :post_comment_id, :integer
    change_column :notifications, :room_id, :integer
    change_column :notifications, :message_id, :integer
  end
end
