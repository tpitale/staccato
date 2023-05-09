require 'spec_helper'

require 'staccato/adapter/net_http'
require 'staccato/adapter/logger'
require 'stringio'

describe Staccato::V4::Tracker do # rubocop:disable RSpec/FilePath
  let(:measurement_id) {'G-XXXXXXX'}
  let(:api_secret) {'qwertyasdfghzxcvbn'}
  let(:client_id) {'123456.123456'}
  let(:tracker) {Staccato::V4.tracker(measurement_id, api_secret, client_id)}

  def uri_with_params
    Staccato::V4.collection_uri.dup.tap {|u|
      u.query = URI.encode_www_form(
        measurement_id: measurement_id, api_secret: api_secret
      )
    }
  end

  describe '#track' do
    context 'with no events enqueued' do
      it 'returns []' do
        expect(tracker.track).to eq([])
      end

      it "doesn't post to Net::HTTP" do
        allow(Net::HTTP).to receive(:post)
        allow(Net::HTTP).to receive(:post_with_body)
        tracker.track
        expect(Net::HTTP).not_to have_received(:post)
        expect(Net::HTTP).not_to have_received(:post_with_body)
      end
    end
  end

  shared_context 'with successful v4 event tracking' do
    let(:response) {instance_double(Net::HTTPOK, body: '')}

    before do
      allow(Net::HTTP).to receive(:post).and_return(response)
    end

    it 'returns the Net::HTTPResponse object' do
      expect(post_the_event(method: 'OAuth2')).to eq([response])
    end
  end

  shared_examples 'v4 login event tracking' do
    include_context 'with successful v4 event tracking'

    it 'posts the event to the measurement v4 API endpoint' do
      post_the_event(method: 'OAuth2')
      expect(Net::HTTP).to have_received(:post)
        .with(uri_with_params, JSON.generate({
          client_id: client_id, events: [
            name: :login, params: {method: 'OAuth2'}
          ]
        }))
    end
  end

  describe '#add(Login.new(...) and #track' do
    it_behaves_like 'v4 login event tracking'
    def post_the_event(**params)
      event = Staccato::V4::Login.new(**params)
      tracker.add(event)
      tracker.track
    end
  end

  describe '#login!' do
    it_behaves_like 'v4 login event tracking'
    def post_the_event(**params)
      tracker.login!(**params)
    end
  end

  describe '#login and #track' do
    it_behaves_like 'v4 login event tracking'
    def post_the_event(**params)
      tracker.login(**params).track
    end
  end

  shared_examples 'v4 purchase event tracking' do
    include_context 'with successful v4 event tracking'

    it 'posts the event to the measurement v4 API endpoint' do
      post_the_event(
        currency: 'USD', value: 49.95,
        transaction_id: 'qwerty-asdfgh-zxcvbn',
        coupon: 'SAVE-ME-MONIES',
        custom: 'beautiful unique snowflake event'
      )
      expect(Net::HTTP).to have_received(:post)
        .with(uri_with_params, JSON.generate({
          client_id: client_id, events: [
            name: :purchase, params: {
              currency: 'USD', value: 49.95,
              transaction_id: 'qwerty-asdfgh-zxcvbn',
              coupon: 'SAVE-ME-MONIES',
              custom: 'beautiful unique snowflake event'
            }
          ]
        }))
    end
  end

  describe '#add(Purchase.new(...) and #track' do
    it_behaves_like 'v4 purchase event tracking'
    def post_the_event(**params)
      event = Staccato::V4::Purchase.new(**params)
      tracker.add(event)
      tracker.track
    end
  end

  describe '#add(:purchase, **params) and #post' do
    it_behaves_like 'v4 purchase event tracking'
    def post_the_event(**params)
      tracker.add(:purchase, **params)
      tracker.post
    end
  end

  describe '#<< {name: :purchase, params: params} and #post' do
    it_behaves_like 'v4 purchase event tracking'
    def post_the_event(**params)
      tracker << {name: :purchase, params: params}
      tracker.post
    end
  end

  describe '#purchase!' do
    it_behaves_like 'v4 purchase event tracking'
    def post_the_event(**params)
      tracker.purchase!(**params)
    end
  end

  describe '#purchase and #track' do
    it_behaves_like 'v4 purchase event tracking'
    def post_the_event(**params)
      tracker.purchase(**params).track
    end
  end

  describe '.default_event_params' do
    before do
      tracker.default_event_params[:foo] = 'bar.com'
    end

    it 'tracks page path and default hostname' do
      allow(Net::HTTP).to receive(:post)
        .and_return(instance_double(Net::HTTPOK))

      tracker.share!(method: 'tooter', content_type: 'iykyk')

      expect(Net::HTTP).to have_received(:post)
        .with(uri_with_params, JSON.generate({
          client_id: client_id,
          events: [
            {
              name: :share,
              params: {
                foo: 'bar.com',
                method: 'tooter',
                content_type: 'iykyk'
              }
            }
          ]
        }))
    end
  end

  context 'with multiple adapters' do
    let(:net_http_adapter) {
      instance_double(Staccato::Adapter::Net::HTTP)
    }
    let(:logdev) { StringIO.new }
    let(:logger) { Logger.new(logdev) }

    before do
      logger.level = Logger::DEBUG
      logger.formatter = ->(sev, time, prog, msg) { msg.to_str }
      allow(net_http_adapter)
        .to receive(:post_with_body)
        .and_return('Net::HTTP response')
      tracker.add_adapter net_http_adapter
      tracker.add_adapter :logger, logger
    end

    it 'returns an array of arrays of responses in order of adapter' do
      expect(tracker.sign_up!)
        .to eq([['Net::HTTP response', true]])
    end

    it 'successfully writes to the logger adapter' do
      tracker.sign_up!
      expect(logdev.string)
        .to eq('params={:measurement_id=>"G-XXXXXXX", ' \
               ':api_secret=>"qwertyasdfghzxcvbn"} ' \
               'body={"client_id":"123456.123456",' \
               '"events":[{"name":"sign_up"}]}')
    end
  end
end
