class RecipesController < ApplicationController
  def index
    @recipes = recipes_cdn.all
  end

  def show
    @id = params[:id]
  end

  private

  def recipes_cdn
    @recipes_cdn ||= Contentful::Recipes.new
  end
end
