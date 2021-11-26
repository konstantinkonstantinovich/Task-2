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
      session[:email] = @user.email
      redirect_to send_mail_path
    else
      render :new
    end
  end

  def edit
    @user = User.find_by(email: session[:email]) if session[:email]
  end

  def update
    @user = User.find_by(email: session[:email]) if session[:email]
    if params[:user][:varify_email] == $msg
      @user.varify_email = params[:user][:varify_email]
      session[:user_id] = @user.id if @user.save
      redirect_to user_page_path(@user.id), notice: "Successfully created account"
    else
      render :edit
    end

  end

  def resend
    @user = User.find_by(email: session[:email]) if session[:email]
    $msg = "#{rand(9)}"+"#{rand(9)}"+"#{rand(9)}"+"#{rand(9)}"
    UserMailer.new_registration_email(@user, $msg).deliver_now
    render :edit
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
