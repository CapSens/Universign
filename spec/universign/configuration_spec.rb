require 'spec_helper'

describe Universign::Configuration do
  after { restore_default_config }
  context 'when endpoint is specified' do
    let(:endpoint) { 'http://my-url.com' }

    before do
      Universign.configure do |config|
        config.endpoint = endpoint
      end
    end

    it 'returns the endpoint' do
      expect(Universign.configuration.endpoint).to eql(endpoint)
    end
  end

  context 'when login is specified' do
    let(:login) { 'my-mail@provider.com' }

    before do
      Universign.configure do |config|
        config.login = login
      end
    end

    it 'returns the login' do
      expect(Universign.configuration.login).to eql(login)
    end
  end

  context 'when password is specified' do
    let(:password) { 'my-mail@provider.com' }

    before do
      Universign.configure do |config|
        config.password = password
      end
    end

    it 'returns the password' do
      expect(Universign.configuration.password).to eql(password)
    end
  end
end
