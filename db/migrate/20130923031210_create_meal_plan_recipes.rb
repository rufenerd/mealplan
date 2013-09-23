class CreateMealPlanRecipes < ActiveRecord::Migration
  def change
    create_table :meal_plan_recipes do |t|
      t.integer :recipe_id
      t.integer :meal_plan_id

      t.timestamps
    end
    add_index :meal_plan_recipes, :recipe_id
    add_index :meal_plan_recipes, :meal_plan_id
  end
end
