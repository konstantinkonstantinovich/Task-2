class RecommendationsController < ApplicationController
  before_action :set_coach

  def new
    @users = @coach.invitations.where(status: 1)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @technique = Technique.find_by_id(params[:technique_id])
    users_ids_list = params[:users_ids]
    users_ids_list.each do |user_id|
      user = User.find_by_id(user_id)
      unless Recommendation.exists?(user_id: user.id, technique_id: @technique.id)
        Recommendation.create(user_id: user.id, coach_id: @coach.id, technique_id: @technique.id, status: 0, step: 0)
        UserNotification.create(body: "Coach #{@coach.name} recommended a Technique for you", user_id: user.id, coach_id: @coach.id ,status: 1)
      else
        flash[:warning] = "User #{user.name} is alraedy passed this technique!"
      end
    end
    redirect_to coach_users_page_path
  end

  private

    def set_coach
      @coach = Current.coach
    end

end
