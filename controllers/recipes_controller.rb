class RecipesController < ApplicationController
  def index
    puts recipes.all
    @title = "Recipes"
  end

  def show
    @id = params[:id]
  end

  private

  def recipes
    @recipes = Contentful::Recipes.new
  end
end
