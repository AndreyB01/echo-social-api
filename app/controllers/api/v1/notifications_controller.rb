class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
  notifications = current_user.notifications
                              .includes(:actor, :notifiable)  # N+1 исправлено
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

    notification.update!(read_at: Time.current)

    render json: {
      message: "Notification marked as read"
    }
  end

  def read_all
    current_user.notifications
                .where(read_at: nil)
                .update_all(read_at: Time.current)

    render json: {
      message: "All notifications marked as read"
    }
  end

  def unread_count
    count = current_user.notifications
                        .where(read_at: nil)
                        .count

    render json: {
      unread_count: count
    }
  end

  private

  def serialize(notification)
    {
      id: notification.id,
      type: notification.notification_type,
      read: notification.read_at.present?,
      created_at: notification.created_at,

      actor: {
        id: notification.actor.id,
        username: notification.actor.username,
        display_name: notification.actor.display_name
      }
    }
  end
end