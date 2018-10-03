# frozen_string_literal: true

# Ruby interface to a Prometheus pushgateway
module PushgatewayMetrics
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  # Main config for this gem
  class Configuration
    attr_accessor :job
    attr_accessor :instance_name
    attr_accessor :gateway

    def initialize
      @job = 'local'
      @instance_name = 'instance'
      @gateway = 'http://localhost/'
    end
  end
end
