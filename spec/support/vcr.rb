VCR.configure do |config|
  config.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock

  config.filter_sensitive_data("<UNIVERSIGN_LOGIN>") { Rails.application.secrets.e_sign_login }
  config.filter_sensitive_data("<UNIVERSIGN_PASSWORD>") { Rails.application.secrets.e_sign_password }
end