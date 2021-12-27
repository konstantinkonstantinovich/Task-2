class RatingsController < ApplicationController
  before_action :set_user

  def finish
    respond_to do |format|
      format.html
      format.js
    end
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

    def set_user
      @user = Current.user
    end

end
