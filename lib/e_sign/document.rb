module ESign
  class Document
    include ESign::Safeguard

    attr_reader :name, :file_content, :file_url
    attr_accessor :params

    def initialize(options = {})
      @params = {}

      options.each do |key, value|
        send("#{key}=", value)
      end
    end

    def self.from_data(data)
      @params = data

      document = ESign::Document.new
      document.params = @params
      document
    end

    def content
      @content ||= params[:content]
    end

    def content=(data)
      @content         = data
      params[:content] =  XMLRPC::Base64.new(data)
    end

    def url
      @url ||= params['url']
    end

    def url=(data)
      @url          = data
      params['url'] = data
    end

    def document_type
      @document_type ||= params['documentType']
    end

    def name
      @name ||= params['name']
    end

    def name=(data)
      @name          = data
      params['name'] = data
    end

    def meta_data
      @meta_data ||= params['metaData']
    end

    def meta_data=(data)
      if !data.is_a?(Hash)
        MetaDataMustBeAHash
      end

      @meta_data = data
    end

    #                          _   _
    #   _____  _____ ___ _ __ | |_(_) ___  _ __  ___
    #  / _ \ \/ / __/ _ \ '_ \| __| |/ _ \| '_ \/ __|
    # |  __/>  < (_|  __/ |_) | |_| | (_) | | | \__ \
    #  \___/_/\_\___\___| .__/ \__|_|\___/|_| |_|___/
    #                   |_|
    class UnknownDocument < StandardError; end
    class NotSigned < StandardError; end
    class MissingDocument < StandardError; end
    class MetaDataMustBeAHash < StandardError; end
    class DocumentURLInvalid < StandardError
      attr_accessor :url

      def initialize(url)
        @url = url
      end

      def to_s
        "Can't find document at '#{@url}''"
      end
    end
  end
end
