require 'bundler'
Bundler.require

require './config/bootstrap'

require 'rspec'

RSpec.configure do |config|
  config.before(:each) { Redis.new(AppConfig.instance.redis_config).flushdb }
end
