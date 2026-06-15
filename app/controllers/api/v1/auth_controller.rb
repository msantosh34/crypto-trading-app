module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_user!, only: [:register, :login, :password_reset, :password_reset_confirm]

      # POST /api/v1/auth/register
      def register
        email = params.require(:email)
        password = params.require(:password)
        password_confirmation = params.require(:password_confirmation)

        begin
          user = AuthService.new(nil, nil).register(email, password, password_confirmation)
          render json: { message: 'User registered successfully', user_id: user.id }, status: :created
        rescue StandardError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/auth/login
      def login
        email = params.require(:email)
        password = params.require(:password)

        user = AuthService.new(email, password).authenticate
        if user
          token = user.create_jwt
          render json: { token: token, user: UserSerializer.new(user) }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      # POST /api/v1/auth/logout
      def logout
        current_user.invalidate_jwt_token
        render json: { message: 'Logged out successfully' }, status: :ok
      end

      # POST /api/v1/auth/password-reset
      def password_reset
        email = params.require(:email)
        token = AuthService.new(nil, nil).generate_reset_token(email)
        if token
          render json: { message: 'Reset link sent to email', token: token }, status: :ok
        else
          render json: { error: 'User not found' }, status: :not_found
        end
      end

      # POST /api/v1/auth/password-reset-confirm
      def password_reset_confirm
        token = params.require(:token)
        new_password = params.require(:new_password)
        confirm_password = params.require(:confirm_password)

        if new_password != confirm_password
          render json: { error: 'Passwords do not match' }, status: :unprocessable_entity
          return
        end

        if AuthService.new(nil, nil).reset_password(token, new_password)
          render json: { message: 'Password reset successful' }, status: :ok
        else
          render json: { error: 'Invalid or expired reset token' }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/auth/change-password
      def change_password
        old_password = params.require(:old_password)
        new_password = params.require(:new_password)
        confirm_password = params.require(:confirm_password)

        if new_password != confirm_password
          render json: { error: 'Passwords do not match' }, status: :unprocessable_entity
          return
        end

        if current_user.valid_password?(old_password)
          current_user.update!(password: new_password, password_confirmation: confirm_password)
          UserMailer.password_changed_notification(current_user).deliver_later
          render json: { message: 'Password changed successfully' }, status: :ok
        else
          render json: { error: 'Old password is incorrect' }, status: :unauthorized
        end
      end
    end
  end
end
