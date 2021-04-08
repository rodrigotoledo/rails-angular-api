class Api::SessionsController < ApplicationController
  def create
    user = User.find_by(email: sessions_params[:email])

    if user && user.valid_password?(sessions_params[:password])
      sign_in user, store: false
      user.generate_auth_token!
      user.save
      render json: user, status: 200
    else
      render json: { errors: 'invalid auth' }, status: 401
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    user.generate_auth_token!
    user.save
    head 204
  end

  protected

  def sessions_params
    params.require(:session).permit(:email, :password)
  end
end
