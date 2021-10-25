class MessagesController < ApplicationController
  before_action :authenticate_user!
  def create
    @room = Room.find(params[:room_id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @message = Message.create(message_params)
      @messages = @room.messages

      @notification = Notification.find_by(room_id: @room.id)
      # notificationテーブル(通知)に保存
      @room.create_notification_message(current_user, @notification.visited_id, @message.id)
    end
  end

  def destroy
    @room = Room.find(params[:room_id])
    @messages = @room.messages
    message = Message.find(params[:id])
    message.destroy
  end

  private

  def message_params
    params.require(:message).permit(:user_id, :room_id, :body).merge(user_id: current_user.id, room_id: @room.id)
  end
end
