# frozen_string_literal: true

require 'spec_helper'

require_relative '../lib/pushgateway_metrics.rb'

describe PushgatewayMetrics::Configuration do
  describe '#configure' do
    let(:gateway) { 'http://not-localhost' }
    let(:instance_name) { 'example_instance' }
    let(:job) { 'a-job' }
    before do
      PushgatewayMetrics.configure do |config|
        config.gateway = gateway
        config.instance_name = instance_name
        config.job = job
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

    it 'uses the configured job name' do
      expect(PushgatewayMetrics.configuration.job).to eq(job)
    end
  end
end
