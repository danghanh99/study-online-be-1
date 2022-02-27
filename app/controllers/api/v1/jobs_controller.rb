class Api::V1::JobsController < ApplicationController
  def create
    job = Job.new(job_params)
    if job.save
      render json: job, status: :created
    else
      render json: job.errors, status: :unprocessable_entity
    end
  end

  def index
    render json: Job.all, status: :ok
  end
  private
    def job_params
      params.permit(:name, :description)
    end
end