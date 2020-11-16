module Contentful
  class Recipes < Contentful::Base
    def all
      entries('recipe')
    end

    def find(id)
      entry id
    end
  end
end
