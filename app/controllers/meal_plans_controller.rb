class MealPlansController < ApplicationController
  def show
    @meal_plan = MealPlan.find(params[:id])
    @title = "Meal Plan #{@meal_plan.id}"
    @shopping_list = @meal_plan.recipes.map(&:recipe_ingredients).flatten.group_by(&:ingredient)
  end

  def index
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
    session[:recipe_ids] = ""
    redirect_to recipes_path
  end
end
