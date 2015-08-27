module ESign
  class Configuration
    attr_accessor :login, :password, :endpoint

    def initialize
      @login    = ''
      @password = ''
      @endpoint = ''
    end
  end

  # @return [ESign::Configuration] ESign's current configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Set ESign's configuration
  # @param config [ESign::Configuration]
  def self.configuration=(config)
    @configuration = config
  end

  # Modify ESign's current configuration
  # @yieldparam [ESign::Configuration] config current ESign config
  # ```
  # ESign.configure do |config|
  #   config.login = "your-mail@provider.com"
  # end
  # ```
  def self.configure
    yield configuration
  end
end
