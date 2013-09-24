module ApplicationHelper
  def num_recipes_in_current_meal_plan
    session[:recipe_ids].try(:split, ',').try(:uniq).try(:size).to_i
  end
end
