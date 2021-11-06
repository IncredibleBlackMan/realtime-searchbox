class SessionsController < ApplicationController
  skip_before_action :authenticate_request!, only: %i[create]
  before_action :find_user, only: %i[create]

  def create
    if session_params[:password] && @user&.authenticate(session_params[:password])
      auth_token = JsonWebToken.encode(user_id: @user.id)
      render json: {
        user: @user,
        auth_token: auth_token
      }, status: :ok
    else
      render json: { errors: 'Invalid email / password' }, status: :unauthorized
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
