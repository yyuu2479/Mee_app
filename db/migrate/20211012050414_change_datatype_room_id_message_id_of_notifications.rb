class ChangeDatatypeRoomIdMessageIdOfNotifications < ActiveRecord::Migration[5.2]
  def change
    change_column :notifications, :room_id, :integer, null: false
    change_column :notifications, :message_id, :integer, null: false
  end
end
