require_relative './app_config'
require_relative './router'

# Load helpers
helpers_path = File.join(AppConfig.root_path, 'helpers')
Dir["#{helpers_path}/**/*.rb"].each { |file| require file }

# Boot controllers
require_relative '../controllers/application_controller'
controllers_path = File.join(AppConfig.root_path, 'controllers')
Dir["#{controllers_path}/**/*.rb"].each { |file| require file }

# Load lib
require_relative '../lib//exceptions//base_exception'
libs_path = File.join(AppConfig.root_path, 'lib')
Dir["#{libs_path}/**/*.rb"].each { |file| require file }

# Load models
models_path = File.join(AppConfig.root_path, 'models')
Dir["#{models_path}/**/*.rb"].each { |file| require file }
