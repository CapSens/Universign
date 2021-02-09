module Universign
  class Error < ::StandardError
    def self.match_class(code)
      {
        73002 => Universign::ErrorWhenSigningPDF, # An error occured when signing the PDF document
        73010 => Universign::InvalidCredentials, # The login and/or password are invalid.
        73025 => Universign::UnknownDocument, # The used transaction id or custom id is invalid
        73027 => Universign::DocumentNotSigned
      }.fetch(code, nil)
    end
  end

  class NotEnoughTokens < Error; end

  class ErrorWhenSigningPDF < Error; end
  class InvalidCredentials < Error; end
  class UnknownException < Error; end

  class UnknownDocument < Error; end
  class DocumentNotSigned < Error; end
  class MissingDocument < Error; end
  class MetaDataMustBeAHash < Error; end
  class DocumentURLInvalid < Error
    attr_accessor :url

    def initialize(url)
      @url = url
    end

    def to_s
      "Can't find document at '#{@url}''"
    end
  end
end
