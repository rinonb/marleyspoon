module Contentful
  class Recipes < Contentful::Base
    def all
      entries('recipe').map do |entry|
        Recipe.build_from_entry(entry)
      end
    end

    def find(id)
      Recipe.build_from_entry entry(id)
    end
  end
end
