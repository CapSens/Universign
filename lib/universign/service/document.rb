module Universign
  module Service
    module Document
      # Retrieve documents signed
      #
      # @return [Array<Universign::Document>]
      def documents
        @documents ||= safeguard do
          result = Universign::Client.call("requester.getDocuments", @transaction_id)
          result.map do |document|
            Universign::Document.from_data(document)
          end
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        attr_reader :documents
      end
    end
  end
end
