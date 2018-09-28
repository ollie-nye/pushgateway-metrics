require_relative './configuration.rb'

require 'prometheus/client'
require 'prometheus/client/push'

# Ruby interface to a Prometheus pushgateway
module PrometheusMetrics
  def self.push
    Metrics.instance.push
  end

  # Definitions for creating and pushing metrics
  class Metrics
    def self.instance
      @instance ||= new
    end

    def errored(value = false)
      @errored ||= value
    end

    def error(message)
      errored true
      puts message
    end

    def registry
      @registry ||= Prometheus::Client.registry
    end

    def push
      push_to_gateway unless errored
    rescue Errno::ECONNREFUSED
      unless errored
        error "Connection to pushgateway on #{gateway} refused. Is it up?"
      end
    rescue Net::OpenTimeout
      unless errored
        error "Connection to pushgateway on #{gateway} timed out. Is it up?"
      end
    end

    def incr(metric, labels = {}, value = 1)
      registry.counter(metric, metric.to_s.humanize) unless
        registry.exist?(metric)
      registry.get(metric).increment(labels, value)
    end

    private

    def push_to_gateway
      Prometheus::Client::Push.new(
        PrometheusMetrics.configuration.instance_name,
        'local',
        PrometheusMetrics.configuration.gateway
      ).add(registry)
    end
  end
end
