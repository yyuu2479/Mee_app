class MessagesController < ApplicationController
  before_action :authenticate_user!
  def create
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      @message = Message.create(message_params)
      @room = @message.room
      @messages = @room.messages

      @visited_user = Notification.find_by(room_id: @room.id)
      # notificationテーブル(通知)に保存
      @room.create_notification_message(current_user, @visited_user.visited_id, @message.id)
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
    params.require(:message).permit(:user_id, :room_id, :body).merge(user_id: current_user.id)
  end
end
