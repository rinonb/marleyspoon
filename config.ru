require 'bundler'
Bundler.require

require './lib/bootstrap'
require './app'

run App.new
