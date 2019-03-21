# frozen_string_literal: true

require 'spec_helper'

def conf
  PushgatewayMetrics.configuration
end

describe PushgatewayMetrics::Metrics do
  let(:instance) { PushgatewayMetrics::Metrics.new }
  let(:request_path) do
    "#{conf.gateway}/metrics/jobs/" \
    "#{conf.job}/instances/" \
    "#{conf.instance_name}"
  end

  before :all do
    PushgatewayMetrics.configure do |config|
      config.gateway = 'http://not-localhost'
      config.instance_name = 'example_instance'
      config.job = 'a-job'
    end
  end

  before do
    allow(conf.logger).to receive(:info)
  end

  describe '#errored' do
    it 'sets true when passed true' do
      instance.errored true
      expect(instance.errored).to be(true)
    end

    it 'sets false when passed false' do
      instance.errored false
      expect(instance.errored).to be(false)
    end
  end

  describe '#error' do
    let(:err_msg) { 'an error message' }

    before do
      instance.error(err_msg)
    end

    it 'outputs the message to the logger' do
      expect(conf.logger).to have_received(:info).with(err_msg)
    end

    it 'sets errored to true' do
      expect(instance.errored).to be(true)
    end
  end

  describe '#push' do
    before do
      stub_request(:post, request_path)
      allow(conf.logger).to receive(:info)
    end

    it 'calls add on the gateway with configured parameters' do
      instance.push
      expect(
        a_request(:post, request_path)
      ).to have_been_made.once
    end

    context 'when the gateway does not exist' do
      let(:err_msg) do
        "Connection to gateway on #{conf.gateway} refused. Is it up?"
      end

      before do
        stub_request(:post, request_path).to_raise(Errno::ECONNREFUSED)
        instance.push
      end

      it 'outputs the message to the logger' do
        expect(conf.logger).to have_received(:info).with(err_msg)
      end
    end

    context 'when the gateway times out' do
      let(:err_msg) do
        "Connection to gateway on #{conf.gateway} timed out. Is it up?"
      end

      before do
        stub_request(:post, request_path).to_timeout
        instance.push
      end

      it 'outputs the message to the logger' do
        expect(conf.logger).to have_received(:info).with(err_msg)
      end
    end
  end

  describe '#incr' do
    before do
      allow(instance.registry).to receive(method)
      allow(
        instance.registry
      ).to receive(:get).with(:metric).and_return(return_metric)
      allow(return_metric).to receive(:increment)
    end

    context 'when the type of a metric is gauge' do
      let(:return_metric) { Prometheus::Client::Gauge.new(:ga, 'test') }
      let(:method) { :gauge }

      it 'uses the type specified' do
        instance.incr(:metric, type: :gauge)
        expect(instance.registry).to have_received(:gauge)
      end
    end

    context 'when setting parameters on a metric' do
      let(:return_metric) { Prometheus::Client::Counter.new(:ca, 'test') }
      let(:method) { :counter }
      let(:value) { 42 }
      let(:labels) { { reporter: 'a reporter', label: 'a label' } }

      it 'uses the labels specified' do
        instance.incr(:metric, labels: labels)
        expect(return_metric).to have_received(:increment).with(labels, 1)
      end

      it 'uses the value specified' do
        instance.incr(:metric, value: value)
        expect(return_metric).to have_received(:increment).with({}, value)
      end
    end
  end
end
