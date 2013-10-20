class RecipeIngredient < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :ingredient

  after_destroy :destroy_ingedient_if_unused

  private

  def destroy_ingedient_if_unused
    ingredient.destroy if ingredient && ingredient.recipes.empty?
  end
end
