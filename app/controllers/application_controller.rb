class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include DeviseSanitizer

  before_action :configure_permitted_parameters, if: :devise_controller?
end
