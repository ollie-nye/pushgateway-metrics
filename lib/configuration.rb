# frozen_string_literal: true

require 'logger'

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
    attr_writer :logger

    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = 'pushgateway-metrics'
      end
    end

    def initialize
      @job = 'local'
      @instance_name = 'instance'
      @gateway = 'http://localhost/'
    end
  end
end
