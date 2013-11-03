class RecipesController < ApplicationController
  def new
    @title = "New Recipe"
    @recipe = Recipe.new(params[:recipe].try(:permit, :name, :instructions, :text, :recipe_ingredients))
  end

  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      process_ingredient_params(@recipe)
      flash[:notice] = "Successfully created new recipe"
      redirect_to :action => :new
    else
      flash[:alert] = @recipe.errors.full_messages.join(" | ")
      flash.keep
      redirect_to :action => :new, :recipe => params[:recipe]
    end
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
    recipe_ids_in_current_mealplan = session[:recipe_ids].split(",").map(&:to_i)

    if params[:search]
      if params[:search].include?("overlap")
        @overlap = true
        ids = Recipe.find(recipe_ids_in_current_mealplan).map(&:ingredient_ids).flatten
        @recipes = @recipes.reject{|r| recipe_ids_in_current_mealplan.include?(r.id)}
      else
        @searched_ingredient_ids = params[:search].split(",").map(&:to_i)
        @num_matching_ingredients_by_recipe_id = {}
        @recipes.each{ |r| @num_matching_ingredients_by_recipe_id[r.id] = r.ingredients_in_common(@searched_ingredient_ids) }

        @recipes = @recipes.sort_by{ |r| @num_matching_ingredients_by_recipe_id[r.id] }.reverse
        @recipes.reject!{ |r| @num_matching_ingredients_by_recipe_id[r.id].zero? }
      end
    else
      @recipes = @recipes.sort_by{ |r| [recipe_ids_in_current_mealplan.include?(r.id) ? 1 : 2, r.name] }
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
    params[:recipe_ingredients].each do |num, ri_params|
      next if ri_params[:ingredient_id].blank? && ri_params[:destroy] != "1"
      match = ri_params[:ingredient_id].match(/NEWINGREDIENT\[(.+)\]/)
      if match
        i = Ingredient.find_by_name(match[1].strip) || Ingredient.create( name: match[1] )
        ri_params.merge!(ingredient_id: i.id)
      end

      destroy_it = ri_params.delete(:destroy) == "1"

      if ri_params[:id].blank?
        RecipeIngredient.create(ri_params.merge(recipe_id: recipe.id)) unless destroy_it
      else
        ri = RecipeIngredient.find(ri_params[:id].to_i)
        if destroy_it
          ri.destroy
        else
          ri.update_attributes(ri_params)
        end
      end
    end
  end
end
