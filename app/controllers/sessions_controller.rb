class SessionsController < ApplicationController
  skip_before_action :authenticate_request!, only: %i[create new]
  before_action :find_user, only: %i[create]

  def create
    if session_params[:password] && @user&.authenticate(session_params[:password])
      auth_token = JsonWebToken.encode(user_id: @user.id)
      cookies.signed[:jwt] = { value: auth_token, httponly: true }

      redirect_to '/articles'
    else
      redirect_to '/login'
    end
  end

  def new
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def find_user
    @user = User.find_by(email: session_params[:email])
  end

  def session_params
    params.require(:user).permit(:email, :password)
  end

end
