class ResetPasswordCoachController < ApplicationController
  def new
  end

  def create
    @coach = Coach.find_by(email: params[:email])
    PasswordMailer.with(coach: @coach).reset_coach.deliver_now if @coach.present?
    render :create
  end

  def edit
      @coach = Coach.find_signed!(params[:token], purpose: 'reset_password_coach')
      rescue ActiveSupport::MessageVerifier::InvalidSignature
        redirect_to sign_in_coach_path, alert: 'Your token has expired. Please try again.'
  end


  def update
    @coach = Coach.find_signed!(params[:token], purpose: 'reset_password_coach')

    if @coach.update(password_params)
      redirect_to sign_in_coach_path, notice: 'Your password was reset successfully. Please sign in'
    else
      render :edit
    end

  end

  private

  def password_params
    params.require(:coach).permit(:password, :password_confirmation)
  end
end
