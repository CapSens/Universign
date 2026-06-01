# frozen_string_literal: true

require "uri"

module Universign
  class Transaction
    include Universign::Safeguard
    include Service::Transaction
    include Service::Document

    attr_reader :transaction_id

    def initialize(transaction_id = nil, sign_url = nil)
      @transaction_id = transaction_id
      @sign_url       = sign_url
    end

    # The transaction info, lazily fetched from Universign on first access.
    # Transactions built via .create expose their sign_url/signer_id without
    # triggering this call.
    #
    # @return [Hash]
    def data
      @data ||= get
    end

    def from_data(data)
      @data = data
    end

    # @return [String]
    #
    # The status of the transaction. The existing statuses are:
    #
    # | Status      | Description                                                |
    # |-------------|------------------------------------------------------------|
    # | `ready`     | Signers can connect and sign                               |
    # | `expired`   | Requested more than 7 days ago, no longer available        |
    # | `canceled`  | A signer has canceled the transaction                      |
    # | `failed`    | An error occured during a signature                        |
    # | `completed` | All signers have successfuly signed                        |
    def status
      data['status']
    end

    # The URL the signer must open to sign (embeddable iframe URL). Always a
    # String. Available without an API call right after .create.
    #
    # @return [String, nil]
    def sign_url
      @sign_url ||= data.dig('signerInfos', current_signer || 0, 'url')
    end

    # The signer id, parsed from the sign URL query param (?id=...).
    #
    # @return [String, nil]
    def signer_id
      query = URI(sign_url.to_s).query
      return if query.nil?

      URI.decode_www_form(query).to_h['id']
    end

    # A list of beans containing information about the signers
    # and their progression in the signature process
    #
    # @return [Array<Universign::SignerInfos>]
    def signers
      Array(data['signerInfos']).map do |signer_info|
        Universign::SignerInfos.from_data(signer_info)
      end
    end

    # A bean containing information about the requester of a
    # transaction
    # @return
    def initiator
      data['initiatorInfo']
    end

    # The index of current signer if the status of transaction
    # is ready or who ended the transactions for other status
    #
    # @return [Integer]
    def current_signer
      data['currentSigner']
    end

    # The creation date or last relaunch date of this transaction
    #
    # @return [Date]
    def created_at
      data['creationDate'].to_date
    end

    # The description of the Transaction
    #
    # @return [String]
    def description
      data['description']
    end

    # Whether the transaction was requested with requesting handwritten signature
    # for each signature field or not.
    #
    # @return [Boolean]
    def each_field
      data['eachField']
    end

    # Whether the transaction is signed... or not !
    #
    # @return [Boolean]
    def signed?
      status == 'completed'
    end
  end
end
