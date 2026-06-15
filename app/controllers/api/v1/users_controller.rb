module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!
      before_action :set_user, only: [:show, :update]

      # GET /api/v1/users/profile
      def profile
        render json: UserSerializer.new(current_user).to_json
      end

      # GET /api/v1/users/:id
      def show
        authorize_user!
        render json: UserSerializer.new(@user).to_json
      end

      # PUT /api/v1/users/profile
      def update
        if current_user.update(user_params)
          render json: { message: 'Profile updated successfully', user: UserSerializer.new(current_user) }, status: :ok
        else
          render json: { error: current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:email, :phone_number)
      end

      def authorize_user!
        render json: { error: 'Unauthorized' }, status: :forbidden unless current_user.admin? || current_user == @user
      end
    end
  end
end
