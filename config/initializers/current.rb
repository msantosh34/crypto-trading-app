# Authentication and authorization
class Current < ActiveSupport::CurrentAttributes
  attribute :user, :admin_user
end

module RailsJwtAuth
  def self.model_name_from_env
    ENV.fetch('JWT_MODEL_NAME', 'User')
  end
end
