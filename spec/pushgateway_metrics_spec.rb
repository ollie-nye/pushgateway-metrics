# frozen_string_literal: true

require 'spec_helper'

require_relative '../lib/pushgateway_metrics.rb'

def conf
  PushgatewayMetrics.configuration
end

describe PushgatewayMetrics::Metrics do
  let(:instance) { PushgatewayMetrics::Metrics.new }

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

    it 'outputs the message to standard out' do
      expect(conf.logger).to receive(:info).with(err_msg)
      instance.error(err_msg)
    end

    it 'sets errored to true' do
      instance.error(err_msg)
      expect(instance.errored).to be(true)
    end
  end

  describe '#push' do
    before do
      stub_request(
        :post,
        "#{conf.gateway}/metrics/jobs/" \
        "#{conf.job}/instances/" \
        "#{conf.instance_name}"
      )
    end

    it 'calls add on the gateway with configured parameters' do
      instance.push
      expect(
        a_request(
          :post,
          "#{conf.gateway}/metrics/jobs/" \
          "#{conf.job}/instances/" \
          "#{conf.instance_name}"
        )
      ).to have_been_made.once
    end
  end

  describe '#incr' do
    let(:return_metric) { Prometheus::Client::Counter.new(:ga, 'test') }
    let(:method) { :counter }

    before do
      allow(instance.registry).to receive(method).and_call_original
      allow(
        instance.registry
      ).to receive(:get).with(:metric).and_return(return_metric)
      allow(return_metric).to receive(:increment).and_call_original
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
