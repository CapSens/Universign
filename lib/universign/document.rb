module Universign
  class Document
    include Universign::Safeguard

    attr_reader :name, :file_content, :file_url
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
      @params = data

      document = Universign::Document.new
      document.params.merge!(@params)
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
      @url ||= params['url']
    end

    def url=(data)
      @url          = data
      params['url'] = data
    end

    # The type of this document
    #
    # @return [String]
    def document_type
      @document_type ||= params['documentType']
    end

    # The file name of this document
    #
    # @return [String]
    def name
      @name ||= params['name']
    end

    def name=(data)
      @name          = data
      params['name'] = data
    end

    def signature_fields=(data)
      if !data.is_a?(Array)
        raise 'SignatureFieldsMustBeAnArray'
      end

      @signature_fields = data
      params['signatureFields'] = data.map do |d|
        raise 'BadSignatureFieldType' unless d.instance_of?(SignatureField)

        d.params
      end
    end

    def check_box_texts
      @check_box_texts ||= params["checkBoxTexts"]
    end

    def check_box_texts=(data)
      if !data.is_a?(Array)
        raise "CheckBoxTextsMustBeAnArray"
      end

      @check_box_texts = data
      params["checkBoxTexts"] = data
    end

    # The meta data of the PDF document
    #
    # @return [Hash]
    def meta_data
      @meta_data ||= params['metaData']
    end

    def meta_data=(data)
      if !data.is_a?(Hash)
        raise MetaDataMustBeAHash
      end

      @meta_data         = data
      params['metaData'] = data
    end
  end
end
