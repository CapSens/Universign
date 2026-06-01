module Universign
  module Safeguard
    # Universign raises this fault code while a signature is still in
    # progress. It is not an error on our side, so we let it bubble up
    # untouched for the caller to handle.
    SIGNATURE_IN_PROGRESS = 73020

    def self.included(klass)
      klass.extend ClassMethods
    end

    def safeguard(&block)
      self.class.safeguard(&block)
    end

    module ClassMethods
      def safeguard
        yield
      rescue XMLRPC::FaultException => ex
        raise ex if ex.faultCode == SIGNATURE_IN_PROGRESS

        raise translate_fault(ex)
      rescue RuntimeError => ex
        raise Universign::InvalidCredentials if ex.message.include?("Authorization failed")

        raise ex
      end

      private

      # Maps an XML-RPC fault to a typed Universign exception, first by
      # fault code, then by fault string as a fallback.
      #
      # @return [Exception]
      def translate_fault(ex)
        known_exception = Universign::Error.match_class(ex.faultCode)
        return known_exception if known_exception

        case ex.faultString
        when /Error on document download for this URL/, /Invalid document URL/
          url = ex.faultString[/<(.+)>/, 1] || "unknown URL"
          Universign::DocumentURLInvalid.new(url)
        when /Not enough tokens/
          Universign::NotEnoughTokens
        when /ID is unknown/
          Universign::UnknownDocument
        else
          ex
        end
      end
    end
  end
end
