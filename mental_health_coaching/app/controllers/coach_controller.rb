class CoachController < ApplicationController
  before_action :require_coach_logged_in!, :set_coach, :set_problems
  def show
  end

  def dashboard
    @problems = @coach.problems
    @notifications = @coach.coach_notifications.order('created_at desc')
    @invitation = @coach.invitations.where(status: 1)
    @total_user = User.all.count
    temp = @coach.recommendations
    techniques_ids = temp.pluck(:technique_id).uniq
    @recommendations = []
    techniques_ids.each { |id| @recommendations << temp.find_by(technique_id: id) }
    @technique_in_used = techniques_ids.length
    @total_coach_users = @coach.invitations.where(status: 1).count
    @user_data = get_techniques_in_progress(@invitation)
    @total_likes = count_likes_on_techniques(@recommendations)
  end

  def library
    @technigues = Technique.all
    if params[:search].present?
      @technigues = search_techniques(@technigues, params[:search])
    else
      if params[:filter].present?
        @technigues = filter_status(@technigues, params[:filter][:status])
        @technigues = filter_problems(@technigues, params[:filter][:problems])
        @technigues = filter_gender(@technigues, params[:filter][:gender])
      end
    end
  end

  def technique_detail
    @technique = Technique.find_by_id(params[:technique_id])
    @steps = @technique.steps
  end

  def coach_users
    @notifications = CoachNotification.where.not(user_id: nil).where(coach_id: @coach.id)
    @invitation = @coach.invitations
    @count = @invitation.where(status: 0).count
    @user_data = get_techniques_in_progress(@invitation)
  end

  def edit
  end

  def update
    if @coach.update(update_params)
      if params[:coach][:social_networks] && params[:coach][:social_networks] != ""
        params[:coach][:social_networks].each do |social_network|
          SocialNetwork.create(name: social_network, coach_id: @coach.id)
        end
      end
      params[:coach][:problems]&.each do |problem|
        @problems.each do |data|
          if problem == data[:name]
            if @coach.problems.find_by(name: data[:name]) == nil
              @coach.problems << data
            end
          end
        end
      end
      CoachNotification.create(body: "You changed your profile settings", status: 1, coach_id: @coach.id)
      flash[:info] = "You updated your profile info!"
      redirect_to coach_page_path
    else
      render :edit
    end
  end

  def password_edit
  end

  def password_update
    if BCrypt::Password.new(@coach.password_digest) == params[:coach][:old_password]
      if @coach.update(password_params)
        CoachNotification.create(body: "You changed your password settings", status: 1, coach_id: @coach.id)
        flash[:info] = "You changed your password!"
        redirect_to coach_page_path
      else
        render :password_edit
      end
    else
      flash[:error] = "You entered invalid password!"
      render :password_edit
    end
  end

  def user_detail
    @invitation = Invitation.find_by(user_id: params[:user_id])
    @recommendations = Recommendation.where(user_id: params[:user_id])
    get_total_time_for_techniques(@recommendations)
    get_current_time_for_techniques(@recommendations)
    @notifications = @coach.coach_notifications.where(user_id: @invitation.user.id)
  end

  private

    def get_total_time_for_techniques(techniques)
      @total_hours = 0
      techniques&.each do |t|
        if t.status == 'compeleted'
          @total_hours += (t.ended_at - t.started_at)/60/60
        end
      end
      @total_hours = @total_hours.round
    end

    def get_current_time_for_techniques(techniques)
      @current_hours = 0
      techniques&.each do |t|
        if t.status == 'in_progress'
          @current_hours += (Time.zone.now - t.started_at)/60/60
        end
      end
      @current_hours = @current_hours.round
    end


    def search_techniques(technigues, param)
      technigues = Technique.search(param)
    end

    def filter_status(techniques, param)
      param&.each do |p|
        if p == "recommend"
          techniques = []
          techniques += Technique.joins(:recommendations).where("recommendations.coach_id = ?", Current.coach.id).uniq
        else
          techniques = []
          techniques += Technique.joins("LEFT JOIN recommendations ON techniques.id = recommendations.technique_id")
            .where("recommendations.technique_id IS NULL AND techniques.status = ?", p)
        end
      end
      techniques
    end

    def filter_gender(technigues, param)
      param&.each do |data|
        technigues = technigues.where(data)
      end
      technigues
    end

    def filter_problems(technigues, param)
      if param.present?
        technigues = Problem.find_by(name: param).techniques
      end
      technigues
    end

    def get_techniques_in_progress(invitation)
      user_data = {}
      invitation.each do |data|
        user_data[data.user.email] = []
        user_recommendations = data.user.recommendations
        user_recommendations.each do |recommendation|
          if recommendation.status == 'in_progress'
            user_data[data.user.email] << recommendation.technique.title
          end
        end
        user_data[data.user.email] << "All techniques completed" if user_data[data.user.email] == []
      end
      user_data
    end

    def count_likes_on_techniques(recommendations)
      techniques_ids = []
      total_likes = 0
      recommendations.each do |data|
        techniques_ids << data.technique_id
      end
      techniques_ids.uniq!
      techniques_ids.each { |id| total_likes += Rating.where(technique_id: id).sum(:like)}
      total_likes
    end

    def update_params
      params.require(:coach).permit(:name, :email, :avatar, :about, :age, :gender, :education, :experience, :licenses)
    end

    def password_params
      params.require(:coach).permit(:password, :password_confirmation)
    end

    def set_coach
      @coach = Current.coach
    end

    def set_problems
      @problems = Problem.all
    end
end
