require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)


module HoowenwareDev
  class Application < Rails::Application
    I18n.enforce_available_locales = false
    #add custom validators path
    config.autoload_paths += %W["#{config.root}/app/validators/"]
  end
end
