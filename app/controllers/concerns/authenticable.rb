module Authenticable
  # :nocov:
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end

  def auth_with_token!
    render json: { errors: 'Unauthorized' }, status: 401 unless current_user.present?
  end
  # :nocov:
end