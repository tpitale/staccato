# frozen_string_literal: true

require 'staccato/v4'
require_relative 'shared_examples'

describe Staccato::V4::Tracker do
  subject(:tracker) {
    Staccato::V4.tracker(measurement_id, api_secret, client_id)
  }

  let(:measurement_id) {'G-XXXXXXX'}
  let(:api_secret) {'qwertyasdfghzxcvbn'}
  let(:client_id) {'123456.123456'}

  describe '.collection_uri' do
    include_examples 'V4.collection_uri'
  end

  describe '.validation_uri' do
    include_examples 'V4.validation_uri'
  end

  describe '.default_adapter_class' do
    include_examples 'default_adapter_class'
  end

  describe '.validation_adapter_class' do
    include_examples 'validation_adapter_class'
  end

  describe '.default_adapter' do
    include_examples 'V4.default_adapter'
  end

  describe '.validation_adapter' do
    include_examples 'V4.validation_adapter'
  end

  describe '#adapters' do
    subject(:adapters) { tracker.adapters }

    context 'with no adapters explicitly added' do
      it 'uses only the default_adapter' do
        expect(adapters).to eq([described_class.default_adapter])
      end

      it { is_expected.to be_an_instance_of(Array) }
      it { is_expected.not_to be_frozen }
      it { is_expected.not_to be_empty }
    end
  end

  describe '#add_adapter' do

    context 'when #add_adapter is called before #adapters' do
      it 'ignores the default adapter' do
        tracker.add_adapter(
          logger = Staccato::Adapter::Logger.new(Staccato::V4.validation_uri)
        )
        expect(tracker.adapters).to eq([logger])
      end
    end

    context 'when called with :logger and a logger' do
      let(:logger) { instance_double(::Logger) }
      let(:formatter) { instance_double(Proc) }

      let!(:adapter) do
        tracker.add_adapter :logger, logger, formatter
      end

      it 'configures a Staccato::Adapter::Logger' do
        expect(adapter).to be_an_instance_of(Staccato::Adapter::Logger)
      end

      it 'sets the uri to V4::COLLECTION_URI' do
        expect(adapter.uri).to equal(Staccato::V4.collection_uri)
      end

      it 'sets the second arg to be its logger' do
        expect(adapter.logger).to equal(logger)
      end

      it 'sets the third arg to be its formatter' do
        expect(adapter.formatter).to equal(formatter)
      end
    end

    context 'when called with :net_http' do
      it 'adds the Tracker.default_adapter' do
        adapter = tracker.add_adapter :net_http
        expect(adapter).to equal(Staccato::V4::Tracker.default_adapter)
      end
    end

    context 'when called with :validation' do
      it 'adds the Tracker.validation_adapter' do
        adapter = tracker.add_adapter :validation
        expect(adapter).to equal(Staccato::V4::Tracker.validation_adapter)
      end
    end

    context 'when #add_adapter is called after #adapters' do
      it 'appends to the default' do
        tracker.adapters
        tracker.add_adapter(
          logger = Staccato::Adapter::Logger.new(Staccato::V4.validation_uri)
        )
        expect(tracker.adapters).to eq([
          described_class.default_adapter, logger
        ])
      end
    end

    context 'when an adapter is appended using #adapters << adapter' do
      it 'appends to the default' do
        tracker.adapters << (
          logger = Staccato::Adapter::Logger.new(Staccato::V4.validation_uri)
        )
        expect(tracker.adapters).to eq([
          described_class.default_adapter, logger
        ])
      end
    end
  end

  describe '#events' do
    subject { tracker.events }

    it { is_expected.to be_an_instance_of(Array) }
    it { is_expected.to be_frozen }
  end

  describe '#add' do
    it 'adds an event hash to the events array' do
      event = {name: :hash_event, params: {a: 1, b: 2}}
      tracker.add event
      expect(tracker.events).to eq([event])
    end

    it 'converts a string or symbol to the name in an event hash' do
      tracker.add 'foo'
      tracker.add :bar
      expect(tracker.events).to eq([{name: :foo}, {name: :bar}])
    end

    it 'adds a Staccato::V4::Event object directly to the events array' do
      event = Staccato::V4::Login.new(method: 'password', foo: 'foo')
      tracker.add event
      expect(tracker.events).to eq([event])
    end

    it 'contructs a Staccato::V4::Event object from its class' do
      tracker.add Staccato::V4::Login
      expect(tracker.events).to eq([Staccato::V4::Login.new])
    end

    context 'with default_event_params' do
      before do
        tracker.default_event_params[:param1] = 123
        tracker.default_event_params[:foo]    = 'bar'
      end

      it 'merges with event hash params' do
        event = {name: :hash_event, params: {a: 1, foo: 'foo'}}
        tracker.add event
        expect(tracker.events)
          .to eq([{name: :hash_event, params: {param1: 123, foo: 'foo', a: 1}}])
      end

      it 'provides params for a string or symbol event' do
        tracker.add 'foo'
        tracker.add :bar
        expect(tracker.events).to eq([
          {name: :foo, params: {param1: 123, foo: 'bar'}},
          {name: :bar, params: {param1: 123, foo: 'bar'}}
        ])
      end

      it 'updates an event with the missing params' do
        event = Staccato::V4::Login.new(method: 'password', foo: 'foo')
        tracker.add event
        expect(tracker.events).to eq([
          Staccato::V4::Login.new(method: 'password', foo: 'foo', param1: 123)
        ])
        expect(tracker.events.first).to equal(event)
      end

      it 'contructs a Staccato::V4::Event object with the defaults' do
        tracker.add Staccato::V4::Login
        expect(tracker.events)
          .to eq([Staccato::V4::Login.new(param1: 123, foo: 'bar')])
      end

    end

    context 'with params kwargs' do
      before do
        tracker.default_event_params[:a] = 1
        tracker.default_event_params[:b] = 2
        tracker.default_event_params[:c] = 3
      end

      it 'overrides both default_event_params and hash params' do
        event = {name: :hash_event, params: {a: 4, b: 5, d: 6, e: 7}}
        tracker.add event, a: 8, d: 9, f: 10
        expect(tracker.events).to eq([{
          name: :hash_event, params: {a: 8, b: 5, c: 3, d: 9, e: 7, f: 10}
        }])
      end

      it 'provides params for a string or symbol event' do
        tracker.add 'foo', a: 4, d: 5
        tracker.add 'bar', a: 4, d: 5
        expect(tracker.events).to eq([
          {name: :foo, params: {a: 4, b: 2, c: 3, d: 5}},
          {name: :bar, params: {a: 4, b: 2, c: 3, d: 5}}
        ])
      end

      it 'updates an event with the params' do
        event = Staccato::V4::Login.new(method: 'password', a: 4, b: 5)
        tracker.add event, method: 'oauth2', a: 6, d: 7
        expect(tracker.events).to eq([
          Staccato::V4::Login.new(method: 'oauth2', a: 6, b: 5, c: 3, d: 7)
        ])
        expect(tracker.events.first).to equal(event)
      end

      it 'contructs a Staccato::V4::Event object with the params' do
        tracker.add Staccato::V4::Login, method: 'oauth2', a: 4
        expect(tracker.events)
          .to eq([Staccato::V4::Login.new(a: 4, b: 2, c: 3, method: 'oauth2')])
      end
    end
  end

  describe '#trim' do
    it 'removes the first 25 events' do
      28.times do |i|
        tracker.add :event, i: i
      end
      expect(tracker.trim).to equal(tracker)
      expect(tracker.events).to eq([
        {name: :event, params: {i: 25}},
        {name: :event, params: {i: 26}},
        {name: :event, params: {i: 27}}
      ])
    end

    it 'takes an optional "count" argument' do
      28.times do |i|
        tracker.add :event, i: i
      end
      tracker.trim(count: 10)
      expect(tracker.events.length).to eq(18)
      tracker.trim(count: 20)
      expect(tracker.events).to be_empty
    end
  end

  describe '#clear' do
    it 'removes all events' do
      28.times do |i|
        tracker.add :event, i: i
      end
      expect(tracker.clear).to equal(tracker)
      expect(tracker.events).to be_empty
    end
  end

end
