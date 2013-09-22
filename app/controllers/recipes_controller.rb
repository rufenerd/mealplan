class RecipesController < ApplicationController
  def new
    @recipe = Recipe.new
  end

  def create
    r = Recipe.new(recipe_params)
    if r.save
      params[:recipe_ingredients].each do |num, ri|
        next if ri[:quantity].blank? && ri[:ingredient_id].blank?
        match = ri[:ingredient_id].match(/NEWINGREDIENT\[(.+)\]/)
        if match
          i = Ingredient.create( name: match[1] )
          ri.merge!(ingredient_id: i.id)
        end
        RecipeIngredient.create(ri.merge(recipe_id: r.id))
      end
      redirect_to action: :show, id: r.id
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
