class RecipeController < ApplicationController
  def new
    @recipe = Recipe.new
  end

  def create
    raise params.inspect
    Recipe.create(params)
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def index
    @recipes = Recipe.all
  end

  def destroy
    Recipe.find(params[:id]).destroy
  end
end
