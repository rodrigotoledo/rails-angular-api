class Api::UsersController < ApplicationController
  respond_to :json
  before_action :set_user, only: [:show, :update, :destroy]
  def show
    respond_with @user
  end

  def update
    if @user.update(user_params)
      render json: @user, status: 200
    else
      render json: {errors: @user.errors}, status: 422
    end
  end

  def destroy
    @user.destroy
    head 204
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201
    else
      render json: {errors: user.errors}, status: 422
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
