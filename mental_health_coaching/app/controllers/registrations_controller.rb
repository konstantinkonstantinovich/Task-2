class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if params[:user][:agree] == "on"
      if @user.save
        $msg = rand(1000...9999).to_s
        UserMailer.new_registration_email(@user, $msg).deliver_now
        session[:email] = @user.email
        redirect_to send_mail_path
      else
        render :new
      end
    else
      flash.now[:alert] = "You must check the box to agree!"
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
      redirect_to user_page_path(@user.id)
    else
      render :edit
    end

  end

  def resend
    @user = User.find_by(email: session[:email]) if session[:email]
    $msg = rand(1000...9999).to_s
    UserMailer.new_registration_email(@user, $msg).deliver_now
    render :edit
  end

  def destroy
    @user = User.find_by(email: session[:email]) if session[:email]
    @user.destroy
    redirect_to sign_up_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
