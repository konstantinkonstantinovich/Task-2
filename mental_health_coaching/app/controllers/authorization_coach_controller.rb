class AuthorizationCoachController < ApplicationController
  def new
  end

  def create
    coach = Coach.find_by(email: params[:email])
    if coach.present? && coach.authenticate(params[:password])
      session[:coach_id] = coach.id
      redirect_to coach_page_path(coach.id), notice: 'Logged in successfully'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end

  end

  def destroy
    session[:coach_id] = nil
    redirect_to root_path
  end
end
