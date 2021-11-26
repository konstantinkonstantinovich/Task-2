class UserMailer < ApplicationMailer
  default from: 'MentalClinic@gmail.com'

  def new_registration_email(user, msg)
    @user = user
    @massege = msg
    mail(to: @user.email, subject: "Verify your email!")
  end

end
