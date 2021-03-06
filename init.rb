require 'rubygems'
require 'rack'
require 'sinatra'
require 'logger'

module MyApp

  ROOT_DIR = File.join File.expand_path(File.dirname(__FILE__)) 

  log_path = File.join ROOT_DIR, 'log', Sinatra::Application.environment.to_s + '.log'
  use Rack::CommonLogger, Logger.new(log_path)

  # require app files
  app_files = File.join(ROOT_DIR, 'app', '**', '*.rb')
  Dir[app_files].each &method(:require)

  class Application < Sinatra::Application

    def initialize(*params)
      read_config
      # setup_db, etc here
      super
    end

    set :views, File.join(ROOT_DIR, 'app', 'views')
    helpers{ include MyApp::Helpers }
    include MyApp::Controllers

    protected
    
      def read_config
        config_file = File.join ROOT_DIR, 'config', 'config.yml'
        @config = YAML.load_file(config_file)[Sinatra::Application.environment.to_s]
      end

  end

end