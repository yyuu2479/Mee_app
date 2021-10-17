class ChangeDatatypeIdNullTrueOfNotifications < ActiveRecord::Migration[5.2]
  def change
    change_column :notifications, :post_id, :integer, null: true
    change_column :notifications, :post_comment_id, :integer, null: true
    change_column :notifications, :room_id, :integer, null: true
    change_column :notifications, :message_id, :integer, null: true
  end
end
