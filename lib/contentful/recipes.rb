module Contentful
  # Fetches contentful recipe entries
  class Recipes < Contentful::Base
    def all
      entries('recipe').map do |entry|
        Recipe.build_from_entry(entry, cache: true)
      end
    end

    def find(id)
      Recipe.find_in_cache(id) ||
        Recipe.build_from_entry(entry(id), cache: true)
    end
  end
end
