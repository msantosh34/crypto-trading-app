class ApplicationController < ActionController::API
  include ActionController::Helpers

  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from StandardError, with: :handle_error
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    @current_user ||= User.find_by(id: decoded_token['user_id']) if decoded_token
  end

  def authenticate_user!
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
  end

  private

  def decoded_token
    return nil unless request.headers['Authorization']

    token = request.headers['Authorization'].split(' ').last
    begin
      @decoded_token ||= JWT.decode(token, ENV['JWT_SECRET_KEY'], true, algorithm: 'HS256').first
    rescue JWT::DecodeError
      nil
    end
  end

  def record_not_found(error)
    render json: { error: "#{error.model} not found" }, status: :not_found
  end

  def handle_error(error)
    Rails.logger.error "Error: #{error.message}\n#{error.backtrace.join('\n')}"
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end

  def user_not_authorized(error)
    render json: { error: 'Not authorized' }, status: :forbidden
  end
end
