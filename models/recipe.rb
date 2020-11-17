# Resource model that parses entries and fetches from cache
class Recipe
  class << self
    def build_from_entry(entry, cache: false)
      recipe = new(entry)
      entry.fields.each do |field, value|
        next unless value

        recipe.send("#{field}=", value) if recipe.respond_to? field
      end
      recipe.store! if cache
      recipe
    end

    def find_in_cache(id)
      cached = Cache.new.get("recipe-#{id}")
      return nil unless cached

      recipe = Recipe.new

      JSON.parse(cached).each do |key, value|
        recipe.send("#{key}=", value)
      end

      recipe
    end
  end

  attr_accessor(
    :id,
    :title,
    :description
  )

  attr_reader(
    :entry,
    :photo,
    :chef
  )

  def initialize(entry = nil)
    return unless entry

    @entry = entry
    @id = entry.id
  end

  def photo=(photo)
    @photo = if photo.is_a? String
               photo
             else
               photo.fields[:file].url
             end
  end

  def tags
    @tags || []
  end

  def tags=(tag_entries)
    @tags = []
    tag_entries.each do |entry|
      @tags << entry_value(entry, :name)
    end
  end

  def chef=(chef)
    @chef = entry_value(chef, :name)
  end

  def store!
    Cache.new.store(cache_key, to_json)
  end

  def cache_key
    "recipe-#{id}"
  end

  def to_json(options = {})
    {
      id: id,
      title: title,
      photo: photo,
      tags: tags,
      description: description,
      chef: chef
    }.merge(options)
  end

  private

  def entry_value(entry, field_name)
    if entry.instance_of? Contentful::Entry
      entry.fields[field_name.to_sym]
    else
      entry
    end
  end
end
