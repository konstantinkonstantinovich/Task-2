class CoachRoomsController < ApplicationController
  before_action :set_room, only: [:show]

  def index
    @coach = Current.coach
    @rooms = @coach.rooms
  end

  def show
    @coach = Current.coach
    @rooms = @coach.rooms
    render 'index'
  end

  private

    def set_room
      @room = Room.find(params[:room_id])
    end

end
