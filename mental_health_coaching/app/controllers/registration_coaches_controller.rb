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
    @problems = Problem.all
    puts params[:avatar]
    if @coach.update(update_params)
      socail_network = SocialNetwork.create(name: params[:coach][:social_networks], coach_id: @coach.id)
      params[:coach][:problems].each do |problem|
        @problems.each do |data|
          if problem == data[:name]
            @coach.problems << data
          end
        end
      end
      @coach.save
      redirect_to coach_page_path(@coach.id)
    else
      render :edit
    end
  end

  private

  def coach_params
    params.require(:coach).permit(:name, :email, :password, :password_confirmation)
  end

  def update_params
    params.require(:coach).permit(:avatar, :age, :gender, :education, :experience, :licenses)
  end

end
