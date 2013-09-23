class MealPlanRecipe < ActiveRecord::Base
  belongs_to :meal_plan
  belongs_to :recipe
end
