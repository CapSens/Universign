require 'singleton'

module Universign
  class Client
    include ::Singleton
    attr_reader :client

    def initialize
      @client          = XMLRPC::Client.new2(
        Universign.configuration.endpoint,
        Universign.configuration.proxy,
        Universign.configuration.timeout
      )
      @client.user     = Universign.configuration.login
      @client.password = Universign.configuration.password
    end

    def method_missing(method, *args, &block)
      if @client.respond_to?(method)
        @client.send(method, *args, &block)
      else
        super(method, *args, &block)
      end
    end
  end
end
