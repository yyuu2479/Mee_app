class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.visiteds.where.not(visitor_id: current_user.id).order(created_at: :desc)
    
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end
end
