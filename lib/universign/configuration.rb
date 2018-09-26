module Universign
  class Configuration
    attr_accessor :login, :password, :endpoint

    def initialize
      @login    = ''
      @password = ''
      @endpoint = ''
    end
  end

  # @return [Universign::Configuration] Universign's current configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Set Universign's configuration
  # @param config [Universign::Configuration]
  def self.configuration=(config)
    @configuration = config
  end

  # Modify Universign's current configuration
  # @yieldparam [Universign::Configuration] config current Universign config
  # ```
  # Universign.configure do |config|
  #   config.login = "your-mail@provider.com"
  # end
  # ```
  def self.configure
    yield configuration
  end
end
