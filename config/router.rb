require 'singleton'
require 'json'

class Router
  class << self
    def app_router
      instance.app_router
    end
  end

  include Singleton

  ROUTES_FILE_PATH = File.join(AppConfig.root_path, 'routes.json')

  attr_reader :app_router

  def initialize
    @app_router = Hanami::Router.new
    process_routes
  end

  def register_route(http_method:, path:, action:)
    app_router.send(http_method, path, to: controller_action(action))
  end

  private

  def process_routes
    routes_file_content = File.read ROUTES_FILE_PATH
    JSON.parse(routes_file_content).each do |route|
      register_route(
        http_method: route['method'],
        path: route['path'],
        action: route['action']
      )
    end
  end

  def controller_action(action)
    controller, method = action.split('#')
    klass = Object.const_get "#{controller.capitalize}Controller"
    klass.new(action: method)
  end
end
