require 'bundler'
Bundler.require

require './config/bootstrap'

Rack::Server.start app: Router.app_router, Port: 9898, Host: '0.0.0.0'
