# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'pushgateway-metrics'
  s.version = '1.1.1'
  s.date = '2018-10-03'
  s.summary = 'An abstracted interface sitting between a Prometheus ' \
              'Pushgateway and your app'
  s.authors = ['Ollie Nye']
  s.files = [
    'lib/pushgateway_metrics.rb',
    'lib/configuration.rb'
  ]
  s.require_paths = ['lib']
end
