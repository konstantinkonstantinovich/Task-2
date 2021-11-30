class AuthorizationController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_page_path(user.id), notice: 'Logged in successfully'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end


  def omniauth
    @user = User.create_from_omniauth(auth)
    if @user.valid?
      session[:user_id] = @user.id
      redirect_to user_page_path(@user.id)
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end

end
