class Ingredient < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :recipes, :through => :recipe_ingredients

  before_save :downcase_name
  before_destroy :ensure_unused


  ALL_CATEGORIES = ["Staples",
                    "Grains/Spices/Oils/Sauces/Canned Foods",
                    "Dairy/Eggs/Deli/Meat",
                    "Bakery/Bread/Tortillas",
                    "Produce/Flowers",
                    "Snack Foods/Packaged Meals/Frozen Foods",
                    "Miscellaneous"]

  private

  def ensure_unused
    return recipes.empty?
  end

  def downcase_name
    self.name = name.downcase
  end
end
