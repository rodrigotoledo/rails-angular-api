class Api::TasksController < ApplicationController
  respond_to :json
  before_action :auth_with_token!
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    render json: current_user.tasks.ransack(params[:q]).result.to_json(include: [:user]), status: :ok
  end

  def show
    respond_with @task
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      render json: @task, status: :created
    else
      render json: {errors: @task.errors}, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task, status: :ok
    else
      render json: {errors: @task.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
  end

  private
    def set_task
      begin
        @task = current_user.tasks.find(params[:id])
      rescue => exception
        logger.info "========= #{request.url} can't be found"
        logger.info exception.message
        head 404
      end
    end

    def task_params
      params.require(:task).permit(:title, :description, :done, :deadline)
    end
end
