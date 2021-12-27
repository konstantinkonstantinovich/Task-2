class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message)

    user = ApplicationController.render(
      partial: 'messages/message_user',
      locals: { message: message }
    )
    coach = ApplicationController.render(
      partial: 'messages/message_coach',
      locals: { message: message }
    )

    ActionCable.server.broadcast("room_channel_#{message.room_id}", {user: user, coach: coach})
  end
end
