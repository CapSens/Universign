VCR.configure do |config|
  config.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock

  config.filter_sensitive_data("<UNIVERSIGN_LOGIN>") { ENV['UNIVERSIGN_LOGIN'] }
  config.filter_sensitive_data("<UNIVERSIGN_PASSWORD>") { ENV['UNIVERSIGN_PASSWORD'] }
end
