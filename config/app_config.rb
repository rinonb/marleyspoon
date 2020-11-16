require 'singleton'

class AppConfig
  include Singleton

  class << self
    def root_path
      AppConfig.instance.root_path
    end
  end

  attr_reader :root_path

  def initialize
    @root_path = File.expand_path './'
  end

  def contentful_credentials
    {
      space_id: ENV['CONTENTFUL_SPACE_ID'],
      environment: ENV['CONTENTFUL_ENVIRONMENT'],
      access_token: ENV['CONTENTFUL_ACCESS_TOKEN']
    }
  end
end
