class ResetPasswordController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user.present?
      PasswordMailer.with(user: @user).reset.deliver_now
      session[:user_email] = @user.email
      render :create
    else
      render :new
    end
  end

  def edit
    @user = User.find_signed!(params[:token], purpose: 'reset_password_edit')
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      redirect_to sign_in_path, alert: 'Your token has expired. Please try again.'
  end


  def update
    @user = User.find_signed!(params[:token], purpose: 'reset_password_edit')

    if @user.update(password_params)
      session[:user_email] = nil
      redirect_to sign_in_path, notice: 'Your password was reset successfully. Please sign in'
    else
      render :edit
    end

  end

  def resend
    @user = User.find_by(email: session[:user_email]) if session[:user_email]
    PasswordMailer.with(user: @user).reset.deliver_now
    render :create
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
