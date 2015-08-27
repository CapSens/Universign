module ESign
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
        known_exception = ESign::ERROR_CODE[ex.faultCode]

        if known_exception
          raise known_exception
        elsif ex.faultString.include?('Error on document download for this URL')
          url = ex.faultString.match(/<(.+)>/)[1] rescue 'unknown URL'
          raise ESign::Document::DocumentURLInvalid.new(url)
        elsif ex.faultString.include?('Invalid document URL')
          url = ex.faultString.match(/<(.+)>/)[1] rescue 'unknown URL'
          raise ESign::Document::DocumentURLInvalid.new(url)
        elsif ex.faultString.include?('Not enough tokens')
          raise ESign::NotEnoughTokens
        elsif ex.faultString.include?('ID is unknown')
          raise ESign::Document::UnknownDocument
        else
          handle_exception(ex, callback)
        end

      rescue RuntimeError => ex
        if ex.message.include?('Authorization failed')
          raise ESign::Client::InvalidCredentials
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
          nil
        end
      end
    end
  end
end
