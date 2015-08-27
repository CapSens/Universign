$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'e_sign'

require 'vcr'
require 'dotenv'

Dotenv.load

load File.dirname(__FILE__) + '/support/vcr.rb'

RSpec.configure do |config|
  config.before(:suite) do
    ESign.configure do |config|
      config.endpoint = ENV['UNIVERSIGN_ENDPOINT']
      config.login    = ENV['UNIVERSIGN_LOGIN']
      config.password = ENV['UNIVERSIGN_PASSWORD']
    end
  end
end