class UserController < ApplicationController
  before_action :require_user_logged_in!

  def new
    @coach = Coach.find_by(id: params[:coach_id])
    @invite = Invitation.find_by(user_id: Current.user.id)
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
      UserNotification.create(body: "You changed your profile settings", status: 1, user_id: @user.id)
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
        UserNotification.create(body: "You changed your password settings", status: 1, user_id: @user.id)
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
    @notifications = UserNotification.where(user_id: @user.id)
    @invite = Invitation.find_by(user_id: @user.id)
    @recommendations = Recommendation.where(user_id: @user.id).order(:status)
  end

  def user_technique_detail
    @user = Current.user
    @technique = Technique.find_by_id(params[:technique_id])
    @recommendation = Recommendation.find_by(user_id: @user.id, technique_id: params[:technique_id])
    next_step = params[:step_id].to_i
    if @recommendation.step + 1 <= @technique.total_steps
      @recommendation.update(step: next_step+1, status: 1)
      @recommendation.update(started_at: Time.zone.now) if @recommendation.started_at == nil
      @step = Step.find_by(number: next_step+1)
    end
  end

  def restart
    @user = Current.user
    @recommendation = Recommendation.find_by(user_id: @user.id, technique_id: params[:technique_id]).update(step: 0, status: 0, started_at: Time.zone.now, ended_at: nil)
    redirect_to user_technique_detail_path(technique_id: params[:technique_id], step_id: 0)
  end


  def coaches_page
    @user = Current.user
    @problems = Problem.all
    @coaches = Coach.all
    @invite = Invitation.find_by(user_id: @user.id)
    if params[:search] != nil
      search_coach(params[:search])
    else
      filter_coach(params[:filter])
    end
  end

  def send_invintation
    @user = Current.user
    @coach = Coach.find_by_id(params[:coach_id])
    if Invitation.find_by(user_id: @user.id) == nil
      Invitation.create(coach_id: @coach.id, user_id: @user.id, status: 0)
      UserNotification.create(body: "You have sent an invitation to coach #{@coach.name}", user_id: @user.id, coach_id: @coach.id, status: 1)
      CoachNotification.create(body: "You have received an invitation to become a coach from a user #{@user.name}", coach_id: @coach.id, user_id: @user.id, status: 1)
      redirect_to user_dashboard_page_path, notice: "You have sent an invitation to coach!"
    else
      flash[:alert] = "First, cancel the invitation to another coach!"
      redirect_to user_coahes_page_path
    end
  end

  def cancel_invite
    @invite = Invitation.find_by_id(params[:invite_id])
    UserNotification.create(body: "You have canceled an invitation to coach #{@invite.coach.name}", user_id: @invite.user.id, coach_id: @invite.coach.id, status: 1)
    @invite.destroy
    redirect_to user_dashboard_page_path(Current.user.id)
  end

  def modal_ask_form
    @coach = Invitation.find_by(user_id: Current.user.id, status: 1).coach
    @invite = Invitation.find_by(user_id: Current.user.id)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def end_cooperation
    @invite = Invitation.find_by_id(params[:invite_id])
    UserNotification.create(body: "You have ended cooperation with coach #{@invite.coach.name}", user_id: @invite.user.id, coach_id: @invite.coach.id, status: 1)
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
        UserNotification.create(body: "You like your Technique", user_id: @user.id, status: 1)
    end
    recommendation = Recommendation.find_by(technique_id: params[:technique_id], user_id: @user.id)
    recommendation.update(status: 2)
    recommendation.update(ended_at: Time.zone.now) if recommendation.ended_at == nil
    redirect_to user_dashboard_page_path
  end

  def dislike
    @user = Current.user
    if Rating.find_by(technique_id: params[:technique_id], user_id: @user.id) == nil
        Rating.create(technique_id: params[:technique_id], user_id: @user.id, like: 0, dislike: 1)
        UserNotification.create(body: "You like your Technique", user_id: @user.id, status: 1)
    end
    recommendation = Recommendation.find_by(technique_id: params[:technique_id], user_id: @user.id)
    recommendation.update(status: 2)
    recommendation.update(ended_at: Time.zone.now) if recommendation.ended_at == nil
    redirect_to user_dashboard_page_path
  end

  private

  def search_coach(param)
    @coaches = Coach.search(param)
  end

  def filter_coach(filter_params)
    @coaches = Coach.where(nil)
    temp = @coaches
    array = []
    if filter_params
      if filter_params[:problems].present?
        @coaches = Problem.find_by(name: filter_params[:problems]).coaches
      end
      if filter_params[:users].present?
        temp&.each do |coach|
          count = Invitation.where(coach_id: coach.id).count
          puts count
          filter_params[:users].each do |user_total|
            if user_total == '5' and count <= 5
              array << coach.id
            end
            if user_total == '5-10' and count > 5 and count <= 10
              array << coach.id
            end
            if user_total == '10-20' and count > 10 and count <= 20
              array << coach.id
            end
            if user_total == '20' and count > 20
              array << coach.id
            end
          end
        end
        array.uniq!
        @coaches = @coaches.where(id: array)
      end
      filter_params[:gender]&.each do |gender|
        @coaches = @coaches.where("gender = ?", 0) if gender == "male"
        @coaches = @coaches.where("gender = ?", 1) if gender == "female"
        @coaches = @coaches.where(nil) if gender == "all"
      end
      filter_params[:gender]&.each do |gender|
        @coaches = @coaches.where("gender = ?", 0) if gender == "male"
        @coaches = @coaches.where("gender = ?", 1) if gender == "female"
        @coaches = @coaches.where(nil) if gender == "all"
      end
      filter_params[:age]&.each do |age|
        if age == "25"
          @coaches = @coaches.where("age <= '25'")
        end
        if age == "25-35"
          @coaches = @coaches.where("age > '25' and age < '35'")
        end
        if age == "35-45"
          @coaches = @coaches.where("age > '35' and age < '45'")
        end
        if age == "45"
          @coaches = @coaches.where("age >= '45'")
        end
      end
    else
      @coaches = Coach.all
    end
  end

  def update_params
    params.require(:user).permit(:name, :email, :avatar_user, :about, :age, :gender)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
