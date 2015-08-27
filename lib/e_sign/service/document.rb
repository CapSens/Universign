module ESign
  module Service
    module Document
      # Retrieve documents signed
      #
      # @return [Array<ESign::Document>]
      def documents
        @client = ESign::Client.instance

        @documents ||= safeguard do
          result = @client.call('requester.getDocuments', @transaction_id)
          result.map do |document|
            ESign::Document.from_data(document)
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
      #   @client = ESign::Client.new.client
      #
      #   safeguard(-> { return false }) do
      #     result = @client.call('requester.getTransactionInfo', transaction_id)
      #     !result['signerInfos'].any? { |s| s['status'] != 'signed' }
      #   end
      # end
      #
      # def signed_with_custom_id(custom_id)
      #   @client = ESign::Client.new.client
      #
      #   safeguard(-> { return false }) do
      #     result = @client.call('requester.getTransactionInfoByCustomId', custom_id)
      #     !result['signerInfos'].any? { |s| s['status'] != 'signed' }
      #   end
      # end
    end
  end
end
