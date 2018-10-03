# frozen_string_literal: true

require_relative './configuration.rb'

require 'prometheus/client'
require 'prometheus/client/push'
require 'active_support/core_ext/string/inflections'

# Ruby interface to a Prometheus pushgateway
module PushgatewayMetrics
  # Definitions for creating and pushing metrics
  class Metrics
    def self.instance
      @instance ||= new
    end

    def conf
      PushgatewayMetrics.configuration
    end

    def gateway
      @gateway ||= Prometheus::Client::Push.new(
        conf.job,
        conf.instance_name,
        conf.gateway
      )
    end

    def errored(value = false)
      @errored ||= value
    end

    def error(message)
      errored true
      conf.logger.info message
    end

    def registry
      @registry ||= Prometheus::Client.registry
    end

    def push
      push_to_gateway unless errored
    rescue Errno::ECONNREFUSED
      unless errored
        error "Connection to gateway on #{conf.gateway} refused. Is it up?"
      end
    rescue Net::OpenTimeout
      unless errored
        error "Connection to gateway on #{conf.gateway} timed out. Is it up?"
      end
    end

    def incr(metric, options = {})
      type = options[:type] || :counter
      labels = options[:labels] || {}
      value = options[:value] || 1

      registry.send(type, metric, metric.to_s.humanize) unless
        registry.exist?(metric)
      registry.get(metric).increment(labels, value)
    end

    private

    def push_to_gateway
      gateway.add(registry)
    end
  end
end
