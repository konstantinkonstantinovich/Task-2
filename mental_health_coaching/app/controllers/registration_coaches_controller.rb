class RegistrationCoachesController < ApplicationController
  def new
    @coach = Coach.new
  end

  def create
    @coach = Coach.new(coach_params)
    if params[:coach][:agree] == "on"
      if @coach.save
        session[:coach_id] = @coach.id
        redirect_to become_coach_update_path
      else
        render :new
      end
    else
      flash.now[:alert] = "You must check the box to agree!"
      render :new
    end
  end

  def edit
    @coach = Coach.find_by(id: session[:coach_id]) if session[:coach_id]
    @problems = Problem.all

  end

  def update
    @coach = Coach.find_by(id: session[:coach_id]) if session[:coach_id]
    puts params[:coach]
  end

  private

  def coach_params
    params.require(:coach).permit(:name, :email, :password, :password_confirmation)
  end

end
