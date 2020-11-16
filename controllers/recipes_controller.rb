class RecipesController < ApplicationController
  def index
    @title = "Recipes"
  end

  def show
    @id = params[:id]
  end
end
