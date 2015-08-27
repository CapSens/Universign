module ESign
  class SignerInfos < ESign::Signer
    # The status of the signer
    #
    # The existing statuses are:
    #
    # |        Status        |                                         Description                                         |
    # |:--------------------:|:-------------------------------------------------------------------------------------------:|
    # | `waiting`            | The signer has not yet been invited to sign. Others signers must sign prior to this user    |
    # | `ready`              | The signer has been invited to sign, but has not tried yet                                  |
    # | `accessed`           | The signer has accessed the signature service                                               |
    # | `code-sent`          | The signer agreed to sign and has been sent an OTP                                          |
    # | `signed`             | The signer has successfully signed.                                                         |
    # | `pending-validation` | The signer has successfully signed and is pending RA validation                             |
    # | `canceled`           | The signer refused to sign, or one of the previous signers canceled or failed its signature |
    # | `failed`             | An error occured during the signature. In this case, error is set                           |
    def status
      data['status']
    end

    # The error message in case status == `failed`
    #
    # @return [String]
    def error
      data['error']
    end

    # The URL of the signature page
    #
    # @return [String]
    def url
      data['url']
    end

    # the action date
    #
    # @return [String]
    def action_date
      data['actionDate']
    end

    # List of refused docs indexes
    #
    # @return [Array<Integer>]
    def refused_docs
      data['refusedDocs']
    end

    # The signer’s email
    #
    # @return [String]
    def email
      data['email']
    end
  end
end
