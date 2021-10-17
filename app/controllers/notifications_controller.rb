class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 現在ログインしているユーザー宛の通知情報を取得
    # その際に自分が自分に通知を送ることになったものは取得せず、降順で並び替えて取得
    @notifications = current_user.visiteds.where.not(visitor_id: current_user.id).order(created_at: :desc).page(params[:page]).per(6)

    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end

  # 自分宛に送られた通知を削除するルーティング
  def destroy
    user = User.find(params[:id])
    notifications = Notification.where(visited_id: user.id)
    notifications.each do |notification|
      notification.destroy
    end
    flash[:alert] = "通知を全て削除しました！"
    redirect_to notifications_path
  end
end
