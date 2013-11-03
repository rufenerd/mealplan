module ApplicationHelper
  def num_recipes_in_current_meal_plan
    return 0 if session[:recipe_ids].blank?
    session[:recipe_ids].split(',').uniq.size
  end
end
