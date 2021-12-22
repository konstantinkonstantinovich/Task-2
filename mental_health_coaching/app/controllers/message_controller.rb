class MessageController < ApplicationController
  before_action :require_user_logged_in!

  def index
    @user = Current.user
    @invite = @user.invitations.first
  end
end
