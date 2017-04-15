require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Securityplus
  class Application < Rails::Application

  
   config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
   config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]
   config.autoload_paths += Dir[Rails.root.join('lib')]
    config.active_record.raise_in_transactional_callbacks = true
  end
end
