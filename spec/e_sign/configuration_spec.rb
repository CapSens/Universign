require 'spec_helper'

describe ESign::Configuration do
  context 'when endpoint is specified' do
    let(:endpoint) { 'http://my-url.com' }

    before do
      ESign.configure do |config|
        config.endpoint = endpoint
      end
    end

    it 'returns the endpoint' do
      expect(ESign.configuration.endpoint).to eql(endpoint)
    end
  end

  context 'when login is specified' do
    let(:login) { 'my-mail@provider.com' }

    before do
      ESign.configure do |config|
        config.login = login
      end
    end

    it 'returns the login' do
      expect(ESign.configuration.login).to eql(login)
    end
  end

  context 'when password is specified' do
    let(:password) { 'my-mail@provider.com' }

    before do
      ESign.configure do |config|
        config.password = password
      end
    end

    it 'returns the password' do
      expect(ESign.configuration.password).to eql(password)
    end
  end
end
