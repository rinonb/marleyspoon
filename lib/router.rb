require 'singleton'
require 'json'

class Router
  include Singleton

  ROUTES_FILE_PATH = File.join(AppConfig.root_path, 'routes.json')

  attr_accessor :routes

  def initialize
    @routes = {}
    process_routes
  end

  def handle(env)
    if (current_route = route(env['REQUEST_METHOD'], env['REQUEST_PATH']))
      klass = current_route[:controller]
      klass.call(current_route[:method])
    else
      [404, {}, ['no!!']]
    end
  end

  def route(method, path)
    routes[build_route_identifier(method: method, path: path)]
  end

  private

  def process_routes
    parsed_routes.each do |route|
      register_route(
        method: route['method'],
        path: route['path'],
        action: route['action']
      )
    end
  end

  def parsed_routes
    @routes_file ||= JSON.parse(File.read(ROUTES_FILE_PATH))
  end

  def register_route(method:, path:, action:)
    route_identifier =
      build_route_identifier(
        method: method,
        path: path
      )
    routes[route_identifier] =
      build_route(
        method: method,
        path: path,
        action: action
      )
  end

  def build_route_identifier(method:, path:)
    "#{method.upcase}_#{path}"
  end

  def build_route(method:, path:, action:)
    controller_name, method_name = action.split '#'
    controller = Object.const_get("#{controller_name.capitalize}Controller")

    {
      http_method: method,
      path: path,
      controller: controller,
      method: method_name
    }
  end
end
