require 'singleton'
require 'json'

class Router
  include Singleton

  ROUTES_FILE_PATH = File.join(AppConfig.root_path, 'routes.json')

  attr_accessor :routes

  def initialize
    @routes = []
    process_routes
  end

  def handle(env)
    if (current_route = route(env['REQUEST_METHOD'], env['REQUEST_PATH']))
      klass = current_route[:controller]
      klass.call(action: current_route[:method], id: current_route[:id])
    else
      [404, {}, ['no!!']]
    end
  end

  def route(method, path)
    current_route = routes.find do |route|
      route[:http_method] == method && !!(path =~ route[:matcher])
    end

    if current_route[:path].end_with? ':id'
      current_route[:id] = path.split('/')[2]
    end

    current_route
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
    routes << build_route(
      method: method,
      path: path,
      action: action
    )
  end

  def build_route(method:, path:, action:)
    controller_name, method_name = action.split '#'
    controller = Object.const_get("#{controller_name.capitalize}Controller")

    {
      http_method: method.upcase,
      path: path,
      controller: controller,
      method: method_name,
      matcher: build_matcher(path)
    }
  end

  def build_matcher(path)
    Regexp.new("^#{path.sub(':id', '[^\/]*$')}$")
  end
end
