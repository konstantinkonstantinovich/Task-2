class CoachController < ApplicationController
  before_action :require_coach_logged_in!
  def show
    @coach = Current.coach
  end

  def dashboard
    @coach = Current.coach
    @problems = @coach.problems
    @notifications = @coach.notifications
  end

  def edit
    @coach = Current.coach
    @problems = Problem.all
  end

  def update
    @coach = Current.coach
    @problems = Problem.all
    if @coach.update(update_params)
      socail_network = SocialNetwork.create(name: params[:coach][:social_networks], coach_id: @coach.id)
      if params[:coach][:problems]
        params[:coach][:problems].each do |problem|
          @problems.each do |data|
            if problem == data[:name]
              @coach.problems << data
            end
          end
        end
      end
      Notification.create(body: "You changed your profile settings", status: 1, coach_id: @coach.id)
      redirect_to coach_page_path(@coach.id)
    else
      render :edit
    end
  end

  def password_edit
    @coach = Current.coach
  end

  def password_update
    @coach = Current.coach
    if BCrypt::Password.new(Current.coach.password_digest) == params[:coach][:old_password]
      if Current.coach.update(password_params)
        Notification.create(body: "You changed your password settings", status: 1, coach_id: @coach.id)
        redirect_to coach_page_path(Current.coach.id)
      else
        render :password_edit
      end
    else
      render :password_edit
    end
  end

  private

  def update_params
    params.require(:coach).permit(:name, :email, :avatar, :about, :age, :gender, :education, :experience, :licenses)
  end

  def password_params
    params.require(:coach).permit(:password, :password_confirmation)
  end
end
