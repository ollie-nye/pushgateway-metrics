# frozen_string_literal: true

require 'sinatra'
require 'pushgateway_metrics'
require 'net/http'
require 'uri'

def metrics
  PushgatewayMetrics::Metrics.instance
end

before do
  content_type :json
end

get '/' do
  PushgatewayMetrics.configure do |c|
    c.gateway = 'http://localhost:9091'
    c.instance_name = 'ruby example instance'
    c.job = 'ruby example job'
  end

  metrics.incr(
    :metric_name,
    type: :counter,
    value: 2,
    labels: { nametype: params['metric'] }
  )
  metrics.push

  Net::HTTP.get_response(URI.parse('http://localhost:9091/metrics')).body
end
