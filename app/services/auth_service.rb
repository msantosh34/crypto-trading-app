class AuthService
  def initialize(email, password)
    @email = email
    @password = password
  end

  def authenticate
    user = User.find_by(email: @email)
    return nil unless user&.valid_password?(@password)
    user
  end

  def register(email, password, password_confirmation)
    user = User.new(email: email, password: password, password_confirmation: password_confirmation)
    return user if user.save
    raise StandardError, user.errors.full_messages.join(', ')
  end

  def generate_reset_token(email)
    user = User.find_by(email: email)
    return nil unless user
    user.generate_reset_password_token!
    user.reset_password_token
  end

  def reset_password(token, new_password)
    user = User.find_by(reset_password_token: token)
    return false unless user && !user.reset_password_token_expires_at.nil? && user.reset_password_token_expires_at > Time.current
    user.update!(password: new_password, password_confirmation: new_password, reset_password_token: nil)
    true
  end
end
