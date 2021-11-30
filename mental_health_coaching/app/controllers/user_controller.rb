class UserController < ApplicationController
  before_action :require_user_logged_in!

  def show
    @user = Current.user
  end

  def edit
    @user = Current.user
    @problems = Problem.all
  end

  def update
    @user = Current.user
    @problems = Problem.all
    if @user.update(update_params)
      params[:user][:problems].each do |problem|
        @problems.each do |data|
          if problem == data[:name]
            @user.problems << data
          end
        end
      end
      redirect_to user_page_path(@user.id)
    else
      render :edit
    end
  end

  private

  def update_params
    params.require(:user).permit(:name, :email, :avatar_user, :about, :age, :gender)
  end

end
