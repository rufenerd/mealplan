class RecipesController < ApplicationController
  def new
    @title = "New Recipe"
    @recipe = Recipe.new
  end

  def create
    r = Recipe.new(recipe_params)
    if r.save
      process_ingredient_params(r)
      flash[:notice] = "Successfully created new recipe"
    else
      flash[:alert] = r.errors.full_messages.join(" | ")
      flash.keep
    end
    redirect_to :action => :new
  end

  def edit
    @recipe = Recipe.find(params[:id])
    @title = "Edit #{@recipe.name}"
  end

  def update
    r = Recipe.find(params[:id])
    if r.update_attributes(params.require(:recipe).permit(:name, :instructions, :text))
      process_ingredient_params(r)
      flash[:notice] = "Successfully edited #{r.name}"
      redirect_to :action => :index
    else
      flash[:alert] = r.errors.full_messages.join(" | ")
      flash.keep
      redirect_to :action => :edit
    end    
  end

  def show
    @recipe = Recipe.find(params[:id])
    @title = @recipe.name
  end

  def index
    @title = "Recipes"
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

  def process_ingredient_params(recipe)
    params[:recipe_ingredients].each do |num, ri|
      next if ri[:quantity].blank? && ri[:ingredient_id].blank?
      match = ri[:ingredient_id].match(/NEWINGREDIENT\[(.+)\]/)
      if match
        i = Ingredient.find_by_name(match[1].strip) || Ingredient.create( name: match[1] )
        ri.merge!(ingredient_id: i.id)
      end

      if ri[:id].blank?
        RecipeIngredient.create(ri.merge(recipe_id: recipe.id))
      else
        RecipeIngredient.find(ri[:id].to_i).update_attributes(ri)
      end
    end
  end
end
