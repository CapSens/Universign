require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  enable_coverage :branch
  minimum_coverage line: 100, branch: 100
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'universign'

# No network is hit by the suite: the XML-RPC client is stubbed in the specs
# that exercise the API, so a static dummy configuration is enough.
def configure_universign
  Universign.configure do |config|
    config.endpoint = 'https://example.test/rpc'
    config.login    = 'login'
    config.password = 'password'
  end
end

def restore_default_config
  configure_universign
end

RSpec.configure do |config|
  config.before(:suite) { configure_universign }
end
