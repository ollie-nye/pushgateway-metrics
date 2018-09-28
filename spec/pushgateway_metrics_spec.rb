# frozen_string_literal: true

require_relative '../lib/pushgateway_metrics.rb'

describe PushgatewayMetrics do
  describe '#configure' do
    let(:gateway) { 'not-localhost' }
    let(:instance_name) { 'example_instance' }
    before do
      PushgatewayMetrics.configure do |config|
        config.gateway = gateway
        config.instance_name = instance_name
      end
    end

    it 'uses the configured gateway' do
      expect(PushgatewayMetrics.configuration.gateway).to eq(gateway)
    end

    it 'uses the configured instance name' do
      expect(
        PushgatewayMetrics.configuration.instance_name
      ).to eq(instance_name)
    end
  end
end
