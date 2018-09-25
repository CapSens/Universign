module Universign
  module Service
    module Document
      # Retrieve documents signed
      #
      # @return [Array<Universign::Document>]
      def documents
        @client = Universign::Client.instance

        @documents ||= safeguard do
          result = @client.call('requester.getDocuments', @transaction_id)
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

      # def signed_with_transaction_id(transaction_id)
      #   @client = Universign::Client.new.client
      #
      #   safeguard(-> { return false }) do
      #     result = @client.call('requester.getTransactionInfo', transaction_id)
      #     !result['signerInfos'].any? { |s| s['status'] != 'signed' }
      #   end
      # end
      #
      # def signed_with_custom_id(custom_id)
      #   @client = Universign::Client.new.client
      #
      #   safeguard(-> { return false }) do
      #     result = @client.call('requester.getTransactionInfoByCustomId', custom_id)
      #     !result['signerInfos'].any? { |s| s['status'] != 'signed' }
      #   end
      # end
    end
  end
end
