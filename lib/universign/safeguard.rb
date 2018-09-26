module Universign
  module Safeguard
    def self.included(klass)
      klass.extend ClassMethods
    end

    def safeguard(callback = nil, &block)
      self.class.safeguard(callback, &block)
    end

    module ClassMethods
      def safeguard(callback = nil, &block)
        block.call
      rescue XMLRPC::FaultException => ex
        if ex.faultCode == 73020
          raise ex
        end

        known_exception = Universign::ERROR_CODE[ex.faultCode]

        if known_exception
          raise known_exception
        elsif ex.faultString.include?('Error on document download for this URL')
          url = ex.faultString.match(/<(.+)>/)[1] rescue 'unknown URL'
          raise Universign::Document::DocumentURLInvalid.new(url)
        elsif ex.faultString.include?('Invalid document URL')
          url = ex.faultString.match(/<(.+)>/)[1] rescue 'unknown URL'
          raise Universign::Document::DocumentURLInvalid.new(url)
        elsif ex.faultString.include?('Not enough tokens')
          raise Universign::NotEnoughTokens
        elsif ex.faultString.include?('ID is unknown')
          raise Universign::Document::UnknownDocument
        else
          handle_exception(ex, callback)
        end

      rescue RuntimeError => ex
        if ex.message.include?('Authorization failed')
          raise Universign::Client::InvalidCredentials
        end
        raise ex
      end

      private

      def handle_exception(ex, callback)
        if callback.respond_to?(:call)
          if callback.lambda? && callback.arity.zero?
            callback.call
          else
            callback.call(ex)
          end
        else
          raise ex
        end
      end
    end
  end
end
