class InvitationsController < ApplicationController
  before_action :set_user

  def new
    @coach = Coach.find_by(id: params[:coach_id])
    @invite = @user.invitations.first
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @coach = Coach.find_by_id(params[:coach_id])
    if Invitation.find_by(user_id: @user.id) == nil
      Invitation.create(coach_id: @coach.id, user_id: @user.id, status: 0)
      UserNotification.create(body: "You have sent an invitation to coach #{@coach.name}", user_id: @user.id, coach_id: @coach.id, status: 1)
      CoachNotification.create(body: "You have received an invitation to become a coach from a user #{@user.name}", coach_id: @coach.id, user_id: @user.id, status: 1)
      flash[:info] = "You have sent an invitation to coach!"
      redirect_to user_dashboard_page_path
    end
  end

  def modal_ask_form
    @invite = @user.invitations.where(status: 1).first
    @coach = @invite.coach
    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @invite = Invitation.find_by_id(params[:invite_id])
    coach = @invite.coach
    room = Room.find_by(user_id: @user.id)
    room.messages.destroy
    room.destroy
    @invite.destroy
    UserNotification.create(body: "You have ended cooperation with coach #{coach.name}", user_id: @user.id, coach_id: coach.id, status: 1)
    flash[:info] = "You have ended cooperation with this coach!"
    redirect_to user_dashboard_page_path
  end


  def cancel_invite
    @invite = Invitation.find_by_id(params[:invite_id])
    coach = @invite.coach
    @invite.destroy
    UserNotification.create(body: "You have canceled an invitation to coach #{coach.name}", user_id: Current.user.id, coach_id: coach.id, status: 1)
    flash[:info] = "You have ended cooperation with this coach!"
    redirect_to user_dashboard_page_path
  end

  def refuse
    @invite = Invitation.find_by_id(params[:invite_id])
    CoachNotification.create(body: "You have rejected #{@invite.user.name} invite", coach_id: @invite.coach.id, user_id: @invite.user.id, status: 1)
    UserNotification.create(body: "Coach #{@invite.coach.name} refused to become your coach", user_id: @invite.user.id, coach_id: @invite.coach.id, status: 1)
    @invite.destroy
    flash[:info] = "You refused user invite!"
    redirect_to coach_users_page_path
  end

  def confirm
    @invite = Invitation.find_by_id(params[:invite_id])
    Room.create(coach_id: @invite.coach.id, user_id: @invite.user.id)
    UserNotification.create(body: "Coach #{@invite.coach.name} agreed to become your coach", user_id: @invite.user.id, status: 1)
    CoachNotification.create(body: "You agreed to become a coach for a user #{@invite.user.name}", coach_id: @invite.coach.id, user_id: @invite.user.id, status: 1)
    @invite.update(status: 1)
    flash[:info] = "You agreed to become a coach for a user #{@invite.user.name}!"
    redirect_to coach_users_page_path
  end

  private

    def set_user
      @user = Current.user
    end

end
