class MealPlansController < ApplicationController
  def show
    if params[:id] == "current"
      @meal_plan = MealPlan.new(recipe_ids: session[:recipe_ids].split(","))
      @title = "Current Meal Plan"
    else
      @meal_plan = MealPlan.find(params[:id])
      @title = "Meal Plan #{@meal_plan.id}"
    end
    @staples, ingredients = @meal_plan.recipes.map(&:ingredients).flatten.uniq.partition{|i| i.category == "Staples" }
    @shopping_list = @meal_plan.recipes.map(&:recipe_ingredients).flatten.reject{|ri| ri.ingredient.category == "Staples" }.group_by(&:ingredient)
    @ingredients_by_category = ingredients.group_by(&:category)
  end

  def index
    @title = "Meal Plans"
    @meal_plans = MealPlan.all
  end

  def new
    @meal_plan = MealPlan.new
  end

  def create
    @meal_plan = MealPlan.new
    @meal_plan.recipes = Recipe.find(session[:recipe_ids].split(",").uniq)
    if @meal_plan.save
      session[:recipe_ids] = ""
    end
    redirect_to meal_plan_path(@meal_plan)
  end

  def destroy
    MealPlan.find(params[:id]).destroy
    redirect_to meal_plans_path
  end

  def add_recipe
    session[:recipe_ids] = (session[:recipe_ids] || "").split(",").push(params[:id]).join(",")
    redirect_to recipes_path
  end

  def remove_recipes
    if params[:id]
      session[:recipe_ids] = (session[:recipe_ids] || "").split(",").reject{|rid| rid == params[:id].to_s }.join(",")
    else
      session[:recipe_ids] = ""
    end
    redirect_to recipes_path
  end
end
