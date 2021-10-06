module NotificationsHelper
  def unchecked_notifications
    @notifications = current_user.visiteds.where(checked: false)
  end
end
