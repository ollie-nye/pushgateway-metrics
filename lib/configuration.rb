# frozen_string_literal: true

# Ruby interface to a Prometheus pushgateway
module PrometheusMetrics
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  # Main config for this gem
  class Configuration
    attr_accessor :gateway
    attr_accessor :instance_name
    def initialize
      @gateway = 'localhost'
      @instance_name = 'instance'
    end
  end
end
