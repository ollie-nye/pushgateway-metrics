# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'pushgateway-metrics'
  s.version = '1.1.4'
  s.date = '2018-10-03'
  s.summary = 'An abstracted interface sitting between a Prometheus ' \
              'Pushgateway and your app'
  s.authors = ['Ollie Nye']
  s.files = [
    'lib/pushgateway_metrics.rb',
    'lib/configuration.rb'
  ]
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec', '~> 3.8.0'
  s.add_development_dependency 'rubocop', '~> 0.59.1'
  s.add_development_dependency 'webmock', '~> 3.4.2'

  s.add_runtime_dependency 'activesupport', '~> 5.2.2.1'
  s.add_runtime_dependency 'prometheus-client', '~> 0.8.0'
end
