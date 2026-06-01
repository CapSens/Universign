# frozen_string_literal: true

module Universign
  class Document
    include Universign::Safeguard

    attr_accessor :params

    # Create a new Universign::Document
    #
    # @param [Hash] options
    # @option options [Array<Byte>] :content Content of the PDF
    # @option options [String] :url URL of the PDF
    # @option options [String] :name Name of the PDF
    # @option options [Hash] :meta_data Hash to join to the PDF
    def initialize(options = {})
      @params = HashWithIndifferentAccess.new

      options.each do |key, value|
        send("#{key}=", value)
      end
    end

    # Create a new document from a Hash
    #
    # @param [Hash] data
    # @return [Universign::Document]
    def self.from_data(data)
      document = new
      document.params.merge!(data)
      document
    end

    # The raw content of the PDF document
    #
    # @return [Array<Byte>]
    def content
      @content ||= params['content']
    end

    def content=(data)
      @content         = data
      params[:content] =  XMLRPC::Base64.new(data)
    end

    # The URL to download the PDF document
    #
    # @return [String]
    def url
      params['url']
    end

    def url=(data)
      params['url'] = data
    end

    # The type of this document
    #
    # @return [String]
    def document_type
      params['documentType']
    end

    # The file name of this document
    #
    # @return [String]
    def name
      params['name']
    end

    def name=(data)
      params['name'] = data
    end

    def signature_fields=(data)
      raise Universign::SignatureFieldsMustBeAnArray unless data.is_a?(Array)

      @signature_fields = data
      params['signatureFields'] = data.map do |d|
        unless d.instance_of?(SignatureField)
          raise Universign::InvalidSignatureField
        end

        d.params
      end
    end

    def check_box_texts
      params['checkBoxTexts']
    end

    def check_box_texts=(data)
      raise Universign::CheckBoxTextsMustBeAnArray unless data.is_a?(Array)

      params['checkBoxTexts'] = data
    end

    # The meta data of the PDF document. Kept verbatim (the ivar) rather
    # than read back from params, which would otherwise stringify the
    # caller's symbol keys through HashWithIndifferentAccess.
    #
    # @return [Hash]
    def meta_data
      @meta_data ||= params['metaData']
    end

    def meta_data=(data)
      raise Universign::MetaDataMustBeAHash unless data.is_a?(Hash)

      @meta_data         = data
      params['metaData'] = data
    end
  end
end
