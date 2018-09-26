require 'singleton'

module Universign
  class Client
    include ::Singleton
    attr_reader :client

    def initialize
      @client          = XMLRPC::Client.new2(Universign.configuration.endpoint)
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

    #                          _   _
    #   _____  _____ ___ _ __ | |_(_) ___  _ __  ___
    #  / _ \ \/ / __/ _ \ '_ \| __| |/ _ \| '_ \/ __|
    # |  __/>  < (_|  __/ |_) | |_| | (_) | | | \__ \
    #  \___/_/\_\___\___| .__/ \__|_|\___/|_| |_|___/
    #                   |_|
    class InvalidCredentials < StandardError; end
    class ErrorWhenSigningPDF < StandardError; end
    class UnknownException < StandardError; end
  end
end
