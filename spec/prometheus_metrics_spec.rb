require_relative '../lib/prometheus_metrics.rb'

describe PrometheusMetrics do
  describe '#configure' do
    let(:gateway) { 'not-localhost' }
    let(:instance_name) { 'example_instance' }
    before do
      PrometheusMetrics.configure do |config|
        config.gateway = gateway
        config.instance_name = instance_name
      end
    end

    it 'uses the configured gateway' do
      expect(PrometheusMetrics.configuration.gateway).to eq(gateway)
    end

    it 'uses the configured instance name' do
      expect(PrometheusMetrics.configuration.instance_name).to eq(instance_name)
    end
  end

  
end