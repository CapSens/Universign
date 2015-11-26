module ESign
  module Service
    module Transaction
      AVAILABLE_OPTIONS = {
        custom_id:                  :customId,
        description:                :description,
        handwritten_signature_mode: :handwrittenSignatureMode,
        certificate_type:           :certificateType,
        language:                   :language,
        identification_type:        :identificationType,
        handwritten_signature:      :handwrittenSignature,
        profile:                    :profile,
        final_doc_sent:             :finalDocSent
      }

      DEFAULT_OPTIONS = {
        handwrittenSignatureMode: 1,
        identificationType:       'sms',
        language:                 'fr',
        certificateType:          'simple'
      }

      # Get a transaction from Universign
      #
      # @return [ESign::Transaction]
      def get
        @client = ESign::Client.instance

        safeguard do
          result = @client.call('requester.getTransactionInfo', @transaction_id)
          self.from_data(result)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # Signs a document
        #
        # @param [Array<ESign::Document>] documents Documents to sign
        # @param [Array<ESign::SignerTransaction>] signers
        # @param [Hash] options
        # @option options: [String] :custom_id Custom ID of the document
        # @option options: [String] :description Description of the signature
        # @option options: [String] :handwritten_signature_mode Type of signature
        # @option options: [String] :certificate_type Type of certificate
        # @option options: [String] :language Document's language
        # @option options: [String] :identification_type
        # @option options: [Boolean] :handwritten_signature
        # @option options: [String] :profile
        # @option options: [Boolean] :final_doc_sent
        #
        # @raise [ArgumentError] Raised if unknown_key passed in options
        #
        # @return [ESign::Transaction]
        def create(documents:, signers:, options: {})
          @client = ESign::Client.instance

          sign_options = DEFAULT_OPTIONS.merge({
            documents: documents.map(&:params),
            signers:   signers.map(&:params),
          })

          options.each do |key, value|
            known_key = AVAILABLE_OPTIONS[key]

            if known_key.present?
              sign_options[known_key] = value
            else
              raise "Unknown Key"
            end
          end

          safeguard do
            result = @client.call("requester.requestTransaction", sign_options)
            ESign::Transaction.new(result['id'], result['url'])
          end
        end
      end
    end
  end
end
