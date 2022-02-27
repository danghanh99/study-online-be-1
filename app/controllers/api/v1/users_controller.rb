class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.order('created_at DESC')
    # render json: {
    #   status: true,
    #   data: @users, each_serializer: UserSerializer
    # }, 
    render json: @users, each_serializer: UserFullSerializer
    # status: :ok
  end

  def show
    render json: @user, serializer: UserFullSerializer
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

  def change_password
    user = User.find_by(id: params[:user_id]) if params[:user_id]
    if user
      if user.password == params[:password]
        length = params[:new_password].strip.length
        if length >= 6 && length <=40
          user.update(password: params[:new_password].strip)
          if user.save
            render json: user, status: :ok
          else
            render json: user.errors, status: :bad_request
          end
        else
          render json: {message: "Invalid password, password length must be in 6..40"}, status: :bad_request
        end 
      else
        render json: {message: "Old password not correct"}, status: :bad_request
      end
    else
      render json: {message: "Couldn't find user"}, status: :not_found
    end
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