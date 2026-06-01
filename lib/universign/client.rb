module Universign
  class Client
    attr_reader :client

    # Convenience: build a fresh client and forward a call to it. A new
    # client (and connection) is used per call, which keeps the wrapper
    # thread-safe — XMLRPC::Client is not safe to share across threads.
    def self.call(*args, &block)
      new.call(*args, &block)
    end

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
        super
      end
    end

    def respond_to_missing?(method, include_private = false)
      @client.respond_to?(method, include_private) || super
    end
  end
end
