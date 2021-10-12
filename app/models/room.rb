class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_many :notifications, dependent: :destroy

  # チャットルームが作成されたら通知が送られるようにするメゾット
  def create_notification_room(current_user, entry)
    notification = current_user.visitors.new(
      visited_id: entry.user_id,
      room_id: id,
      action: 'chat_room'
    )
    notification.checked = true if notification.visitor_id == notification.visited_id
    
    notification.save if notification.valid?
  end
  
  # チャットルーム内でメッセージが送られた際に通知が送られるようにするメゾット
  def create_notification_message(current_user, visited_id, message_id)
    temps = Message.select(:user_id).where(room_id: id).where.not(user_id: current_user.id).distinct
    
    temps.each do |temp|
      save_notification_message(current_user, temp[:user_id], message_id)
    end
    
    save_notification_message(current_user, visited_id, message_id) if temps.blank?
  end
  
  def save_notification_message(current_user, visited_id, message_id)
    notification = current_user.visitors.new(
      visited_id: visited_id,
      room_id: id,
      message_id: message_id,
      action: 'chat_message'
    )
    notification.checked = true if notification.visitor_id == notification.visited_id
    
    notification.save if notification.valid?
  end
end
