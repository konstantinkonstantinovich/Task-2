class MessagesController < ApplicationController
   before_action :set_message, only: [:show]

  def index
    @messages = Message.all
  end

  def show
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.user = User.find_by(id: session[:author_user_id]) if session[:author_user_id]
    @message.coach = Coach.find_by(id: session[:author_coach_id]) if session[:author_coach_id]
    @message.save

    session[:author_user_id] = nil
    session[:author_coach_id] = nil
    SendMessageJob.perform_later(@message)

  end



  private

    def set_message
      @message = Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:body, :room_id)
    end

end
