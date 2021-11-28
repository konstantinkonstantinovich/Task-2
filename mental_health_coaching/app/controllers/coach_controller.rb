class CoachController < ApplicationController

  def show
    @coach = Current.coach
  end
end
