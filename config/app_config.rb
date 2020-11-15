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
end
