class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    puts params[:user]
    if @user.save
      $msg = "#{rand(9)}"+"#{rand(9)}"+"#{rand(9)}"+"#{rand(9)}"
      UserMailer.new_registration_email(@user, $msg).deliver_now
      session[:user_id] = @user.id
      redirect_to send_mail_path
    else
      render :new
    end
  end

  def edit
    @user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def update
    @user = User.find_by(id: session[:user_id]) if session[:user_id]
    if params[:user][:varify_email] == $msg
      @user.varify_email = params[:user][:varify_email]
      @user.save
      redirect_to root_path, notice: "Successfully created account"
    else
      render :edit
    end

  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
