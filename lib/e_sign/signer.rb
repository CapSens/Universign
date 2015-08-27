module ESign
  class Signer
    attr_accessor :params

    def initialize(options = {})
      @params = {}

      options.each do |key, value|
        send("#{key}=", value)
      end
    end

    def self.from_data(data)
      @params = data
    end

    # This signer’s firstname
    #
    # @return [String]
    def first_name
      @first_name || params['firstName']
    end

    def first_name=(data)
      @first_name        = data
      params[:firstname] = data
    end

    # This signer’s lastname
    #
    # @return [String]
    def last_name
      @last_name || params['lastName']
    end

    def last_name=(data)
      @last_name        = data
      params[:lastname] = data
    end
  end
end
