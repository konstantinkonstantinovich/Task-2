class UserController < ApplicationController
  before_action :require_user_logged_in!

  def show
    puts request.params
    @user = Current.user
  end

end
