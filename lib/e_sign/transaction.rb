module ESign
  class Transaction
    include ESign::Safeguard
    include Service::Transaction
    include Service::Document

    attr_reader :transaction_id, :url, :data

    def initialize(transaction_id = nil, url = nil)
      @transaction_id = transaction_id
      @url            = url
      @data           = {}
    end

    def from_data(data)
      @data = data
    end

    # @return [String]
    #
    # The status of the transaction. The existing statuses are:
    #
    # | Status      | Description                                                                                      |
    # |-------------|--------------------------------------------------------------------------------------------------|
    # | `ready`     | Signers can connect and sign                                                                     |
    # | `expired`   | The transaction has been requested more than 7 days ago. It will no more be available to signers |
    # | `canceled`  | A signer has canceled the transaction. Signers will no more be able to connect to the service    |
    # | `failed`    | An error occured during a signature. The signers won’t be able to connect to the service         |
    # | `completed` | All signers have successfuly sign, the requester can retrieve the documents                      |
    def status
      data['status']
    end

    # @return [Array<String>]
    def url
      @url ||= begin
        data['signerInfos'].map { |si| si['url'] }
      end
    end

    # A list of bean containing information about the signers
    # and their progression in the signature process
    #
    # @return [Array<ESign::Signer]
    def signers
      raise 'NotImplementedYet'
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
      @signed ||= begin
        status == 'completed'
        # || !result['signerInfos'].any? { |signer| signer['status'] != 'signed' }
      end
    end

    ########################

    private

    def client
      @client ||= ESign::Client.new.client
    end
  end
end
