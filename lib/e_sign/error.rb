
module ESign
  module Error
    autoload :Client, 'client'
    ERROR_CODE = {
      73002 => ESign::Client::ErrorWhenSigningPDF, # An error occured when signing the PDF document
      73010 => ESign::Client::InvalidCredentials,  # The login and/or password are invalid.
      73025 => ESign::Document::UnknownDocument,    # The used transaction id or custom id is invalid
      73027 => ESign::Document::NotSigned
    }

    class ESignError < StandardError; end
    class NotEnoughTokens < ESignError; end
  end
end
