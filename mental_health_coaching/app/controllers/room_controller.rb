class RoomController < ApplicationController

  def index
    @user = Current.user
    @invite = @user.invitations.first
    @room = @user.room
    @messages = @room.messages
  end

end
