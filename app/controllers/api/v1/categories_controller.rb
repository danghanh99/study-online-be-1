class Api::V1::CategoriesController < ApplicationController
  def create
    category = Category.new(category_params)
    if category.save
      render json: category, status: :created
    else
      render json: category.errors, status: :unprocessable_entity
    end
  end

  def index
    render json: Category.all, status: :ok
  end
  private
    def category_params
      params.permit(:name, :description)
    end
end