$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'universign'

require 'vcr'
require 'dotenv'

Dotenv.load

load File.dirname(__FILE__) + '/support/vcr.rb'

RSpec.configure do |config|
  config.before(:suite) do
    Universign.configure do |config|
      config.endpoint = ENV['UNIVERSIGN_ENDPOINT']
      config.login    = ENV['UNIVERSIGN_LOGIN']
      config.password = ENV['UNIVERSIGN_PASSWORD']
    end
  end
end

def restore_default_config
  Universign.configure do |config|
    config.endpoint = ENV['UNIVERSIGN_ENDPOINT']
    config.login    = ENV['UNIVERSIGN_LOGIN']
    config.password = ENV['UNIVERSIGN_PASSWORD']
  end
end
