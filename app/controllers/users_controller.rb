class UsersController < ApplicationController
  skip_before_action :authenticate_request!

  def create
    user = User.new(user_create_params)
    if user.save
      auth_token = JsonWebToken.encode(user_id: user.id)

      render json: {
        user: user,
        auth_token: auth_token
      }, status: :created
    else
      render json: { errors: user.errors }.to_json, status: :unprocessable_entity
    end
  end

  private

  def user_create_params
    params.permit(:email,
                  :first_name,
                  :last_name,
                  :bio,
                  :password,
                  :password_confirmation)
  end
end
