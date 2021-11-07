class ApplicationController < ActionController::Base
  require 'json_web_token'

  protect_from_forgery prepend: true
  skip_before_action :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found!

  before_action :authenticate_request!

  # Validates the token and user and sets the @current_user scope
  def authenticate_request!
    @current_user_id = session[:user_id]

    if @current_user_id.blank?
      token = cookies.signed[:jwt]
      begin
        jwt_payload = JsonWebToken.decode(token).first
        @current_user_id = jwt_payload['user_id']
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        @has_error = true
      end
    end

    redirect_to '/login' if @current_user_id.blank? || @has_error
  end

  def user_signed_in?
    current_user.present?
  end

  # Sets the @current_user with the user_id from payload
  def current_user
    @current_user ||= User.find_by(id: @current_user_id)
  end

  def fail_if_unauthenticated!
    unless user_signed_in?
      render json: {
        errors: 'Unauthorised. Sign in to access this resource.'
      }, status: :unauthorized
    end
  end

  def render_not_found!
    render json: { errors: 'Resource not found.' }, status: :not_found
  end

  private

  def user_not_authorized
    render json: { errors: 'You are not authorized to perform this action.' }, status: :unauthorized
  end
end
