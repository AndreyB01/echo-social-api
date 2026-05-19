class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    notifications = current_user.notifications
                                .includes(:actor)
                                .order(created_at: :desc)
                                .page(params[:page])
                                .per(params[:per_page] || 20)

    render json: {
      data: NotificationSerializer.render_collection(notifications),
      meta: {
        current_page: notifications.current_page,
        next_page: notifications.next_page,
        prev_page: notifications.prev_page,
        total_pages: notifications.total_pages,
        total_count: notifications.total_count
      }
    }
  end

  def read
    notification = current_user.notifications.find(params[:id])
    ReadNotificationService.call(notification: notification)

    render json: { message: "Notification marked as read" }
  end

  def read_all
  ReadAllNotificationsService.call(
    user: current_user
  )

  render json: {
    message: "All notifications marked as read"
  }
end

  def unread_count
    count = current_user.notifications
                        .where(read_at: nil)
                        .count

    render json: { unread_count: count }
  end
end