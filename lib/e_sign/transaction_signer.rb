module ESign
  class TransactionSigner < Signer
    attr_accessor :phone_number, :signature, :callbacks

    def initialize(options = {})
      super(options)

      options.each do |key, value|
        send("#{key}=", value)
      end
    end

    # This signer’s organization
    #
    # @params [String] data
    def organization=(data)
      @organization         = data
      params[:organisation] = data
    end

    # This signer’s e-mail address
    #
    # @params [String] data
    def email=(data)
      @email                = data
      params[:emailAddress] = data
    end

    # This signer’s mobile phone number that should be
    # written in the international format
    #
    # Mandatory if the authentication by sms is activated
    #
    # @params [String] data
    def phone_number=(data)
      @phone_number     = data
      params[:phoneNum] = data
    end

    # The role of this transaction actor
    #
    # |    Role    |                                        Description                                       |
    # |:----------:|:----------------------------------------------------------------------------------------:|
    # |  `signer`  | (default) This actor is a signer and he will be able to view the documents and sign them |
    # | `observer` |         This actor is an observer and he will be able only to view the documents         |
    #
    # @params [String] data
    def role=(data)
      @role         = data
      params[:role] = data
    end

    # A description of a visible PDF signature field. If none
    # provided, no signature field will be produced on the
    # signed document
    #
    # @params [ESign::SignatureField] data
    def signature_field=(data)
      if !data.instance_of?(ESign::SignatureField)
        raise 'BadSignatureFieldType' # TODO: create custom Exception
      end

      @signature_field        = data
      params[:signatureField] = data
    end

    # This signer’s birth date. This is an option for the certified
    # signature
    #
    # @params [Date] data
    def birtdate=(data)
      @birthdate         = data
      params[:birthDate] = data
    end

    # The url to where the signer will be  redirected, after the signatures are completed.
    # If it is null it takes the value of {ESign::Transaction#success_url}
    # If it is also null, it takes the default Universign success URL
    def success_url=(data)
      @success_url        = data
      params[:successURL] = data
    end

    def cancel_url=(data)
      @cancel_url        = data
      params[:cancelURL] = data
    end

    def fail_url=(data)
      @fail_url        = data
      params[:failURL] = data
    end

    # Which authentication type will be used when a signer will attempt to sign.
    #
    # The available values are :
    # |   Type  |                                                                                    Description                                                                                   |
    # |:-------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
    # |  `none` |                                                           The signer won’t be asked an authentication code when signing                                                          |
    # | `email` |       The signer will be sent a authentication code by e-mail. Using this option implies that this signer has a valid email property set, otherwise, an exception is thrown      |
    # |  `sms`  | The signer will be sent a authentication code by sms. Using this option implies that this signer has a valid `phone_number` property set, in other cases, an exception is thrown |
    def identification_type=(data)
      @identification_type        = data
      params[:identificationType] = data
    end
  end
end
