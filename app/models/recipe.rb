class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :meal_plan_recipes, dependent: :destroy
  has_many :meal_plans, through: :meal_plan_recipes

  validates_presence_of :name

  def ingredients_in_common(other_ingredients)
    if other_ingredients.first.is_a?(Numeric)
      (ingredient_ids & other_ingredients.map(&:to_i)).size
    else
      (ingredients & other_ingredients).size
    end
  end

  def text_with_span_on_ingredient_names
    ingredients.map(&:name).each do |ingredient_name|
      text.gsub!(ingredient_name, "<span class='ingredient_name'>#{ingredient_name}</span>")
      text.gsub!(ingredient_name.capitalize, "<span class='ingredient_name'>#{ingredient_name.capitalize}</span>")
    end
    text
  end
end
