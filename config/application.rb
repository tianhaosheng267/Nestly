

require_relative "boot"

require "rails/all"



Bundler.require(*Rails.groups)

module Project6JadeOnWheels
  class Application < Rails::Application
    
    config.load_defaults 8.1

    
    
    
    config.autoload_lib(ignore: %w[assets tasks])

    
    
    
    
    
    config.time_zone = "Eastern Time (US & Canada)"
    config.active_record.default_timezone = :local
    
  end
end
