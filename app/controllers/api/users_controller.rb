class Api::UsersController < ApplicationController
  respond_to :json
  before_action :set_user, only: [:show, :destroy]
  def show
    respond_with @user
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
end
