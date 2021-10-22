class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_room, only: [:show]

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      # チャットルーム内で既に送信されたメッセージを取得
      @messages = @room.messages
      # チャットルーム内でメッセージを新規投稿するための空インスタンス
      @message = Message.new
      # チャットルーム内にエントリーしているユーザーの情報を出すため取得
      @entries = @room.entries

      @another_entry = @entries.where.not(user_id: current_user.id).first
    else
      redirect_back fallback_location: root_path
    end
  end

  def create
    @room = Room.create
    # 現在ログインしているユーザーがチャットルームにエントリーした情報をentriesテーブルに保存している
    Entry.create(user_id: current_user.id, room_id: @room.id)
    # フォローされたユーザーがチャットルームにエントリーした情報をentriesテーブルに保存している
    entry2 = Entry.create(entry_params)

    @room.create_notification_room(current_user, entry2)
    redirect_to room_path(@room.id)
  end

  private

  def entry_params
    params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id)
  end

  def correct_room
    room = Room.find(params[:id])
    unless Entry.where(user_id: current_user, room_id: room.id)
      flash[:alert] = "あなたのチャットルームではありません！"
      redirect_to root_path
    end
  end
end
