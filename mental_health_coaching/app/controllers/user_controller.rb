class UserController < ApplicationController
  before_action :require_user_logged_in!, :set_user, :set_problems

  def finish
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
  end

  def update
    if @user.update(update_params)
      params[:user][:problems]&.each do |problem|
        @problems.each do |data|
          if problem == data[:name]
            if @user.problems.find_by(name: data[:name]) == nil
              @user.problems << data
            end
          end
        end
      end
      UserNotification.create(body: "You changed your profile settings", status: 1, user_id: @user.id)
      flash[:info] = "You updated your profile info!"
      redirect_to user_page_path
    else
      render :edit
    end
  end

  def password_edit
  end

  def password_update
    if BCrypt::Password.new(Current.user.password_digest) == params[:user][:old_password]
      if Current.user.update(password_params)
        UserNotification.create(body: "You changed your password settings", status: 1, user_id: @user.id)
        flash[:info] = "You changed your password!"
        redirect_to user_page_path
      else
        render :password_edit
      end
    else
      flash[:error] = "You entered invalid password!"
      render :password_edit
    end
  end

  def dashboard
    @problems = @user.problems
    @notifications = @user.user_notifications.order('created_at desc')
    @invite = @user.invitations.first
    @recommendations = @user.recommendations.order(:status)
    @total_hours = get_total_time_for_techniques(@recommendations)
    @current_hours = get_current_time_for_techniques(@recommendations)
    @total_competed_techniques = @user.recommendations.where(status: 'compeleted').count
    @total_in_progress_technique = @user.recommendations.where(status: 'in_progress').count
  end

  def user_technique_detail
    @technique = Technique.find_by_id(params[:technique_id])
    @recommendation = Recommendation.find_by(user_id: @user.id, technique_id: params[:technique_id])
    next_step = params[:step_id].to_i
    if next_step < @technique.total_steps
      @recommendation.update(step: next_step+1, status: 1)
      @recommendation.update(started_at: Time.zone.now) if @recommendation.started_at == nil
      @step = Step.find_by(number: next_step+1)
    else
      @step = Step.find_by(number: next_step)
    end
  end

  def restart
    @recommendation = Recommendation.find_by(user_id: @user.id, technique_id: params[:technique_id]).update(step: 0, status: 0, started_at: Time.zone.now, ended_at: nil)
    redirect_to user_technique_detail_path(technique_id: params[:technique_id], step_id: 0)
  end


  def coaches_page
    @coaches = Coach.all
    @invite = Invitation.find_by(user_id: @user.id)
    if params[:search] != nil
      @coaches = search_coach(@coaches, params[:search])
    else
      if params[:filter].present?
        @coaches = filter_expertise(@coaches, params[:filter][:problems])
        @coaches = filter_users_count(@coaches, params[:filter][:users])
        @coaches = filter(@coaches, params[:filter][:gender])
        @coaches = filter(@coaches,params[:filter][:age])
      end
    end
  end

  def my_techniques
    @invite = @user.invitations.find_by(status: 1)
    @recommendations = @user.recommendations
  end


  def like
    unless Rating.exists?(technique_id: params[:technique_id], user_id: @user.id)
        Rating.create(technique_id: params[:technique_id], user_id: @user.id, like: 1, dislike: 0)
        UserNotification.create(body: "You like your Technique", user_id: @user.id, status: 1)
    end
    recommendation = Recommendation.find_by(technique_id: params[:technique_id], user_id: @user.id)
    recommendation.update(status: 2)
    recommendation.update(ended_at: Time.zone.now) if recommendation.ended_at == nil
    flash[:info] = "You like Technique"
    redirect_to user_dashboard_page_path
  end

  def dislike
    unless Rating.exists?(technique_id: params[:technique_id], user_id: @user.id)
        Rating.create(technique_id: params[:technique_id], user_id: @user.id, like: 0, dislike: 1)
        UserNotification.create(body: "You dislike your Technique", user_id: @user.id, status: 1)
    end
    recommendation = Recommendation.find_by(technique_id: params[:technique_id], user_id: @user.id)
    recommendation.update(status: 2)
    recommendation.update(ended_at: Time.zone.now) if recommendation.ended_at == nil
    flash[:info] = "You dislike Technique"
    redirect_to user_dashboard_page_path
  end

  private

    def search_coach(coaches, param)
      coaches = Coach.search(param)
    end

    def filter_expertise(coaches, param)
      if param.present?
        coaches = Problem.find_by(name: param).coaches
      end
      coaches
    end

    def filter(coaches, param)
      param&.each do |data|
        coaches = coaches.where(data)
      end
      coaches
    end

    def filter_users_count(coaches, param)
      if param.present?
        temp = coaches
        array = []
        temp&.each do |coach|
          count = coach.invitations.where(status: 1).count
          param.each do |user_total|
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
        coaches = coaches.where(id: array)
      end
      coaches
    end

    def get_total_time_for_techniques(techniques)
      total_hours = 0
      techniques&.each do |t|
        if t.status == 'compeleted'
          total_hours += (t.ended_at - t.started_at)/60/60
        end
      end
      total_hours = total_hours.round
    end

    def get_current_time_for_techniques(techniques)
      current_hours = 0
      techniques&.each do |t|
        if t.status == 'in_progress'
          current_hours += (Time.zone.now - t.started_at)/60/60
        end
      end
      current_hours = current_hours.round
    end

    def update_params
      params.require(:user).permit(:name, :email, :avatar_user, :about, :age, :gender)
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def set_user
      @user = Current.user
    end

    def set_problems
      @problems = Problem.all
    end
end
