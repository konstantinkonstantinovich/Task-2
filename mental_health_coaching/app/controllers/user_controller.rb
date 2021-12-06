class UserController < ApplicationController
  before_action :require_user_logged_in!

  def new
    @coach = Coach.find_by(id: params[:coach_id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def finish
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @user = Current.user
    @problems = Problem.all
  end

  def update
    @user = Current.user
    @problems = Problem.all
    if @user.update(update_params)
      if params[:user][:problems]
        params[:user][:problems].each do |problem|
          @problems.each do |data|
            if problem == data[:name]
              @user.problems << data
            end
          end
        end
      end
      Notification.create(body: "You changed your profile settings", status: 1, user_id: @user.id)
      redirect_to user_page_path(@user.id)
    else
      render :edit
    end
  end

  def password_edit
    @user = Current.user
  end

  def password_update
    @user = Current.user
    if BCrypt::Password.new(Current.user.password_digest) == params[:user][:old_password]
      if Current.user.update(password_params)
        Notification.create(body: "You changed your password settings", status: 1, user_id: @user.id)
        redirect_to user_page_path(Current.user.id)
      else
        render :password_edit
      end
    else
      render :password_edit
    end
  end

  def dashboard
    @user = Current.user
    @problems = @user.problems
    @notifications = @user.notifications
    @invite = Invitation.find_by(user_id: @user.id)
    @recommendations = Recommendation.where(user_id: @user.id).order(:status)
  end

  def user_technique_detail
    @user = Current.user
    @technique = Technique.find_by_id(params[:technique_id])
    @recommendation = Recommendation.find_by(user_id: @user.id, technique_id: params[:technique_id])
    next_step = params[:step_id].to_i
    if next_step < @technique.total_steps
      @recommendation.update(step: next_step+1, status: 1)
      @recommendation.update(started_at: Time.zone.now) if @recommendation.started_at == nil
      @step = Step.find_by(number: next_step+1)
    else
      @recommendation.update(status: 2)
      @recommendation.update(ended_at: Time.zone.now) if @recommendation.ended_at == nil
      @step = Step.find_by(number: next_step)
    end
  end

  def restart
    @user = Current.user
    @recommendation = Recommendation.find_by(user_id: @user.id, technique_id: params[:technique_id]).update(step: 0, status: 0)
    redirect_to user_technique_detail_path(technique_id: params[:technique_id], step_id: 0)
  end


  def coaches_page
    @user = Current.user
    @coahes = Coach.all
    @problems = Problem.all
    @invite = Invitation.find_by(user_id: @user.id)
  end

  def send_invintation
    @user = Current.user
    @coach = Coach.find_by_id(params[:coach_id])
    if Invitation.find_by(user_id: @user.id) == nil
      Invitation.create(coach_id: @coach.id, user_id: @user.id, status: 0)
      Notification.create(body: "You have sent an invitation to coach #{@coach.name}", user_id: @user.id, status: 1)
      Notification.create(body: "You have received an invitation to become a coach from a user #{@user.name}", coach_id: @coach.id, user_id: @user.id, status: 1)
      redirect_to user_dashboard_page_path, notice: "You have sent an invitation to coach!"
    else
      flash[:alert] = "First, cancel the invitation to another coach!"
      redirect_to user_coahes_page_path
    end
  end

  def cancel_invite
    @invite = Invitation.find_by_id(params[:invite_id])
    Notification.create(body: "You have canceled an invitation to coach #{@invite.coach.name}", user_id: @invite.user.id, status: 1)
    @invite.destroy
    redirect_to user_dashboard_page_path(Current.user.id)
  end

  def end_cooperation
    @invite = Invitation.find_by_id(params[:invite_id])
    Notification.create(body: "You have ended cooperation with coach #{@invite.coach.name}", user_id: @invite.user.id, status: 1)
    @invite.destroy
    redirect_to user_dashboard_page_path(Current.user.id)
  end

  def my_techniques
    @user = Current.user
    @invite = Invitation.find_by(user_id: @user.id, status: 1)
    @recommendations = Recommendation.where(user_id: @user.id)
  end


  def like
    @user = Current.user
    if Rating.find_by(technique_id: params[:technique_id], user_id: @user.id) == nil
        Rating.create(technique_id: params[:technique_id], user_id: @user.id, like: 1, dislike: 0)
        Notification.create(body: "You like your Technique", user_id: @user.id, status: 1)
    end
    redirect_to user_dashboard_page_path
  end

  private

  def update_params
    params.require(:user).permit(:name, :email, :avatar_user, :about, :age, :gender)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
