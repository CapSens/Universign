module Universign
  class SignerInfos < Signer
    # The status of the signer
    #
    # The existing statuses are:
    #
    # - `waiting`: not yet invited to sign; other signers must sign first
    # - `ready`: invited to sign, but has not tried yet
    # - `accessed`: has accessed the signature service
    # - `code-sent`: agreed to sign and has been sent an OTP
    # - `signed`: has successfully signed
    # - `pending-validation`: signed and pending RA validation
    # - `canceled`: refused to sign, or a previous signer canceled/failed
    # - `failed`: an error occurred during the signature (see `error`)
    def status
      data["status"]
    end

    # The error message in case status == `failed`
    #
    # @return [String]
    def error
      data["error"]
    end

    # The URL of the signature page
    #
    # @return [String]
    def url
      data["url"]
    end

    # the action date
    #
    # @return [String]
    def action_date
      data["actionDate"]
    end

    # List of refused docs indexes
    #
    # @return [Array<Integer>]
    def refused_docs
      data["refusedDocs"]
    end

    # The signer’s email
    #
    # @return [String]
    def email
      data["email"]
    end
  end
end
