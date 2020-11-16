require 'bundler'
Bundler.require

require './lib/bootstrap'

Rack::Server.start app: Router.app_router, Port: 9292
