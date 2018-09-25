module Universign
  module Error
    autoload :Client, 'client'
    ERROR_CODE = {
      73002 => Universign::Client::ErrorWhenSigningPDF, # An error occured when signing the PDF document
      73010 => Universign::Client::InvalidCredentials, # The login and/or password are invalid.
      73025 => Universign::Document::UnknownDocument, # The used transaction id or custom id is invalid
      73027 => Universign::Document::NotSigned
    }

    class UniversignError < StandardError; end
    class NotEnoughTokens < UniversignError; end
  end
end
