class Api::UsersController < ApplicationController
  respond_to :json
  before_action :auth_with_token!, only: [:update, :destroy]
  before_action :set_user, only: :show
  def show
    render json: current_user.to_json(include: [:tasks]), status: :ok
  end

  def update
    if current_user.update(user_params)
      render json: current_user.to_json(include: [:tasks]), status: :ok
    else
      render json: {errors: current_user.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    head 204
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: {errors: user.errors}, status: :unprocessable_entity
    end
  end

  protected

  def set_user
    begin
      @user = User.find(params[:id])
    rescue => exception
      logger.info "========= #{request.url} can't be found"
      logger.info exception.message
      head 404
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
