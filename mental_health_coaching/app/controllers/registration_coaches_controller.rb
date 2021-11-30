class RegistrationCoachesController < ApplicationController
  def new
    @coach = Coach.new
  end

  def create
    @coach = Coach.new(coach_params)
    if params[:coach][:agree] == "on"
      if @coach.save
        CoachMailer.varify_email(@coach).deliver_now
        session[:coach_id] = @coach.id
        render :create
      else
        render :new
      end
    else
      flash.now[:alert] = "You must check the box to agree!"
      render :new
    end
  end

  def edit
    # @coach = Coach.find_by(id: session[:coach_id]) if session[:coach_id]
    @problems = Problem.all
    @coach = Coach.find_signed!(params[:token], purpose: 'become_coach_update')
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to sign_in_path, alert: 'Your token has expired. Please try again.'
  end

  def update
    @coach = Coach.find_by(id: session[:coach_id]) if session[:coach_id]
    puts @coach
    @problems = Problem.all
    if @coach.update(update_params)
      socail_network = SocialNetwork.create(name: params[:coach][:social_networks], coach_id: @coach.id)
      params[:coach][:problems].each do |problem|
        @problems.each do |data|
          if problem == data[:name]
            @coach.problems << data
          end
        end
      end
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
