class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.order('created_at DESC')
    render json: {
      status: true,
      data: @users
    }, 
    status: :ok
  end

  def create
    @user = User.new(user_params)
    @user.email = @user.email.downcase
    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def delete
  end

  def login
    user = User.find_by(email: params[:email].downcase)
    if user
      if user.password == params[:password]
        render json: user, status: :ok
      else
        render json: {message: "Invalid email or password"}, status: :bad_request
      end
    else
      render json: {message: "Invalid email or password"}, status: :bad_request
    end
  end

  def join_group
  end

  def log_out
  end

  def forgot_password
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.permit(:name, :email, :password, :gender, :job)
    end
end