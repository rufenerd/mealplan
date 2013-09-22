class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  def ingredients_in_common(other_ingredients)
    if other_ingredients.first.match(/^\d+$/)
      (ingredient_ids & other_ingredients.map(&:to_i)).size
    else
      (ingredients & other_ingredients).size
    end
  end
end
