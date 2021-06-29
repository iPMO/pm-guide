# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

run Rails.application
Rails.application.load_server

require File.expand_path('../app.rb', __FILE__)

use Rack::ShowExceptions

run IpMO.new 
