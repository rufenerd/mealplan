module ApplicationHelper
  def recipe_ids_in_current_meal_plan
    return [] if session[:recipe_ids].blank?
    session[:recipe_ids].split(',').map(&:to_i)
  end
end
