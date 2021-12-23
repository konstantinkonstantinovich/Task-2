class MessageController < ApplicationController

  def create
    @message = Message.create(message_params)
    @message.room = Room.find_by(id: params[:room_id]) if params[:room_id]
    @message.user = User.find_by(id: session[:author_user_id]) if session[:author_user_id]
    @message.coach = Coach.find_by(id: session[:author_coach_id]) if session[:author_coach_id]
    @message.save
    redirect_back(fallback_location: root_path)
  end



  private

    def message_params
      params.require(:message).permit(:body)
    end

end
