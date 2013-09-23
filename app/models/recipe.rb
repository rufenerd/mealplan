class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :meal_plan_recipes, dependent: :destroy
  has_many :meal_plans, through: :meal_plan_recipes

  validates_presence_of :name

  after_destroy :destroy_unused_ingredients

  def ingredients_in_common(other_ingredients)
    if other_ingredients.first.is_a?(Numeric)
      (ingredient_ids & other_ingredients.map(&:to_i)).size
    else
      (ingredients & other_ingredients).size
    end
  end

  private

  def destroy_unused_ingredients
    ingredients.select{|i| i.recipes == [self] }.each(&:destroy)
  end
end
