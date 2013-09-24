class Ingredient < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :recipes, :through => :recipe_ingredients

  before_save :downcase_name
  before_destroy :ensure_unused

  private

  def ensure_unused
    return recipes.empty?
  end

  def downcase_name
    self.name = name.downcase
  end
end
