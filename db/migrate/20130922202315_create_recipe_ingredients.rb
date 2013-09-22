class CreateRecipeIngredients < ActiveRecord::Migration
  def change
    create_table :recipe_ingredients do |t|
      t.integer :recipe_id
      t.integer :ingredient_id
      t.string :quantity

      t.timestamps

      t.index :recipe_id
      t.index :ingredient_id
    end
  end
end
