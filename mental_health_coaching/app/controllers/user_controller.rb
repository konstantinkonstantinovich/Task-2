class UserController < ApplicationController
  before_action :require_user_logged_in!

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
  end

  private

  def update_params
    params.require(:user).permit(:name, :email, :avatar_user, :about, :age, :gender)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
