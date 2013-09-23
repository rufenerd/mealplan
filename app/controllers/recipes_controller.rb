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
          i = Ingredient.find_by_name(match[1].strip) || Ingredient.create( name: match[1] )
          ri.merge!(ingredient_id: i.id)
        end
        RecipeIngredient.create(ri.merge(recipe_id: r.id))
      end
      flash[:notice] = "Successfully created new recipe"
    end
    redirect_to :action => :new
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def index
    @recipes = Recipe.all

    if params[:search]
      if params[:search].include?("overlap")
        ids = Recipe.find(session[:recipe_ids].split(",")).map(&:ingredient_ids).flatten
      else
        ids = params[:search].split(",").map(&:to_i)
      end

      @recipes = @recipes.sort_by{|r| r.ingredients_in_common(ids) }.reverse
    else
      @recipes = @recipes.sort_by(&:name)
    end
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
