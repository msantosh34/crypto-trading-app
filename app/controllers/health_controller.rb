class HealthController < ApplicationController
  skip_before_action :authenticate_user!

  def check
    render json: { status: 'healthy', timestamp: Time.current }
  end
end
