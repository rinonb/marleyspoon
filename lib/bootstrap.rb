require_relative '../config/app_config'
require_relative './router'

# Boot controllers
require_relative '../controllers/application_controller'
controllers_path = File.join(AppConfig.root_path, 'controllers')
Dir["#{controllers_path}/**/*.rb"].each { |file| require file }

Router.instance
