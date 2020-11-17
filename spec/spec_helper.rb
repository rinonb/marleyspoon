require 'bundler'
Bundler.require

require './config/bootstrap'

require 'rspec'

RSpec.configure do |config|
  config.before(:each) { Redis.new.flushdb }
end
