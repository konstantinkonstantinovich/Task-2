class CoachController < ApplicationController
  before_action :require_coach_logged_in!
  def show
    @coach = Current.coach
  end

  def dashboard
    @coach = Current.coach
    @problems = @coach.problems
    @notifications = CoachNotification.where(coach_id: @coach.id)
    @invitation = Invitation.where(coach_id: @coach.id)
    @recommendations = Recommendation.where(coach_id: @coach.id)
  end

  def library
    @coach = Current.coach
    @problems = Problem.all
    @technigues = Technique.all
  end

  def technique_detail
    @coach = Current.coach
    @technique = Technique.find_by_id(params[:technique_id])
    @steps = Step.where(techniques_id: @technique.id)
  end

  def new
    @coach = Current.coach
    @users = @coach.invitations
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @coach = Current.coach
    @technique = Technique.find_by_id(params[:technique_id])
    users_names_list = params[:users].select! { |element| element&.size.to_i > 0 }
    users_names_list.each do |user_name|
      user = User.find_by(name: user_name)
      if Recommendation.find_by(user_id: user.id, technique_id: @technique.id) == nil
        Recommendation.create(user_id: user.id, coach_id: @coach.id, technique_id: @technique.id, status: 0, step: 0)
        UserNotification.create(body: "Coach #{@coach.name} recommended a Technique for you", user_id: user.id, coach_id: @coach.id ,status: 1)
      else
        flash[:warning] = "User #{user_name} is alraedy passed this technique!"
      end
    end
    redirect_to coach_users_page_path
  end

  def coach_users
    @coach = Current.coach
    @notifications = CoachNotification.where.not(coach_id: @coach.id, user_id: nil)
    @count = Invitation.where(coach_id: @coach.id, status: 0).count
    @invitation = Invitation.where(coach_id: @coach.id)
  end

  def refuse
    @invite = Invitation.find_by_id(params[:invite_id])
    CoachNotification.create(body: "You have rejected #{@invite.user.name} invite", coach_id: @invite.coach.id, user_id: @invite.user.id, status: 1)
    UserNotification.create(body: "Coach #{@invite.coach.name} refused to become your coach", user_id: @invite.user.id, coach_id: @invite.coach.id, status: 1)
    @invite.destroy
    redirect_to coach_users_page_path(Current.coach.id)
  end

  def confirm
    @invite = Invitation.find_by_id(params[:invite_id])
    UserNotification.create(body: "Coach #{@invite.coach.name} agreed to become your coach", user_id: @invite.user.id, status: 1)
    CoachNotification.create(body: "You agreed to become a coach for a user #{@invite.user.name}", coach_id: @invite.coach.id, user_id: @invite.user.id, status: 1)
    @invite.update(status: 1)

    redirect_to coach_users_page_path(Current.coach.id)
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
      CoachNotification.create(body: "You changed your profile settings", status: 1, coach_id: @coach.id)
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
        CoachNotification.create(body: "You changed your password settings", status: 1, coach_id: @coach.id)
        redirect_to coach_page_path(Current.coach.id)
      else
        render :password_edit
      end
    else
      render :password_edit
    end
  end

  def user_detail
    @coach = Current.coach
    @invitation = Invitation.find_by(user_id: params[:user_id])
    @recommendations = Recommendation.where(user_id: params[:user_id])
    @notifications = CoachNotification.where(coach_id: @coach.id, user_id: @invitation.user.id)
  end

  private

  def update_params
    params.require(:coach).permit(:name, :email, :avatar, :about, :age, :gender, :education, :experience, :licenses)
  end

  def password_params
    params.require(:coach).permit(:password, :password_confirmation)
  end
end
