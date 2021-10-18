module NotificationsHelper
  def unchecked_notifications
    current_user.visiteds.where(checked: false)
  end
end
