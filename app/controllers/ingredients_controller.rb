class IngredientsController < ApplicationController
  def index
    @title = "Ingredients"
    @ingredients = Ingredient.all
  end

  def update
    @ingredient = Ingredient.find(params[:id])
    if @ingredient.update_attributes(params.require(:ingredient).permit(:category, :name))
      render :json => "OK"
    else
      render :json => "FAIL"
    end
  end
end
