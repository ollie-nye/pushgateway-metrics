Gem::Specification.new do |s|
  s.name = 'prometheus-metrics'
  s.version = '0.1.0'
  s.date = '2018-09-28'
  s.summary = 'An abstracted interface sitting between a Prometheus ' \
              'Pushgateway and your app'
  s.files = [
    'lib/prometheus-metrics.rb',
    'lib/configuration.rb'
  ]
  s.require_paths = ['lib']
end
