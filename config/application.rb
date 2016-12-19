require_relative 'boot'

require 'rails/all'

# For implementing csv features.
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PhysicalPropertyParser
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # config.eager_load_paths += [
    #   Rails.root.join("lib", "feed_parser"),
    # ]

    # https://github.com/cyu/rack-cors
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    # https://github.com/blowmage/minitest-rails
    config.generators do |g|
      g.assets   = false
      g.helpers  = false
      g.jbuilder = false
      g.template_engine :slim
      g.test_framework :minitest, spec: true, fixture: false
      g.fixture_replacement :factory_girl, dir: 'test/factories'
    end

    #===> Browserify
    # http://inlehmansterms.net/2016/04/29/modern-javascript-in-rails/
    config.browserify_rails.commandline_options = '-t [ babelify --presets [ es2015 stage-2 stage-0 ] ]'
  end
end
