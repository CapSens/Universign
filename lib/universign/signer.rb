module Universign
  class Signer
    attr_accessor :params

    def initialize(options = {})
      @params = {}

      options.each do |key, value|
        send("#{key}=", value)
      end
    end

    def self.from_data(data)
      signer = new
      signer.params.merge!(data)
      signer
    end

    # This signer’s firstname
    #
    # @return [String]
    def first_name
      params[:firstname] || params['firstName']
    end

    def first_name=(data)
      params[:firstname] = data
    end

    # This signer’s lastname
    #
    # @return [String]
    def last_name
      params[:lastname] || params['lastName']
    end

    def last_name=(data)
      params[:lastname] = data
    end

    # The raw data backing this signer when built from an API response.
    #
    # @return [Hash]
    def data
      params
    end
  end
end
