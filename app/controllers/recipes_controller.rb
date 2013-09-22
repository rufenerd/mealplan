class RecipesController < ApplicationController
  def new
    @recipe = Recipe.new
  end

  def create
    if Recipe.create(recipe_params)
      redirect_to :action => :index
    else
      redirect_to :action => :new
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def index
    @recipes = Recipe.all
  end

  def destroy
    Recipe.find(params[:id]).destroy
    redirect_to :action => :index
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :text)
  end

end
