module NotificationsHelper
  # 現在ログインしているユーザー宛の通知でcheckedカラムがfalseの通知を取得
  def unchecked_notifications
    current_user.visiteds.where(checked: false)
  end
end
