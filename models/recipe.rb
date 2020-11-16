class Recipe
  class << self
    def build_from_entry(entry)
      recipe = new(entry)
      entry.fields.each do |field, value|
        next unless value
        recipe.send("#{field}=", value) if recipe.respond_to? field
      end
      recipe
    end
  end

  attr_accessor(
    :title,
    :photo,
    :tags,
    :description,
    :chef
  )
  attr_reader :entry

  def initialize(entry)
    @entry = entry
  end

  def photo=(photo_entry)
    @photo = photo_entry.fields[:file].url
  end

  def tags=(tag_entries)
    @tags = []
    tag_entries.each do |entry|
      @tags << entry.fields[:name]
    end
  end

  def chef=(chef_entry)
    @chef = chef_entry.fields[:name]
  end

  def to_json
    {
      title: title,
      photo: photo,
      tags: tags,
      description: description,
      chef: chef
    }
  end
end
