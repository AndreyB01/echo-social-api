class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    paginator = Pagination::CursorPaginator.new(
      current_user.notifications
                  .includes(:actor)
                  .order(created_at: :desc),
      cursor: params[:cursor],
      limit: params[:limit]
    )

    result = paginator.call

    render_success(
      data: NotificationSerializer.render_collection(
        result[:records]
      ),
      meta: result[:meta]
    )
  end

  def read
    notification = current_user.notifications.find(params[:id])
    ReadNotificationService.call(notification: notification)

    render_success(
      data: { message: "Notification marked as read" }
    )
  end

  def read_all
    ReadAllNotificationsService.call(user: current_user)

    render_success(
      data: { message: "All notifications marked as read" }
    )
  end

  def unread_count
    count = current_user.notifications
                        .where(read_at: nil)
                        .count

    render_success(
      data: { unread_count: count }
    )
  end
end