class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    notifications = current_user.notifications
                                .includes(:actor, :notifiable)
                                .order(created_at: :desc)
                                .limit(50)

    render json: {
      data: notifications.map { |notification| serialize(notification) }
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