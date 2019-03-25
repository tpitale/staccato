require 'spec_helper'

require 'staccato/adapter/http'
require 'staccato/adapter/net_http'

describe Staccato::Tracker do
  let(:uri) {Staccato.ga_collection_uri}
  let(:tracker) {Staccato.tracker('UA-XXXX-Y')}
  let(:response) {stub(:body => '', :status => 201)}

  before(:each) do
    SecureRandom.stubs(:uuid).returns('555')
    Net::HTTP.stubs(:post_form).returns(response)
  end

  describe "#pageview" do
    before(:each) do
      expect(tracker.pageview(path: '/foobar', title: 'FooBar', hostname: 'mysite.com')).to eq(response)
    end

    it 'tracks page path and page title' do
      expect(Net::HTTP).to have_received(:post_form).with(uri, {
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'dh' => 'mysite.com',
        'dp' => '/foobar',
        'dt' => 'FooBar'
      })
    end
  end

  describe "#event" do
    before(:each) do
      tracker.event({
        category: 'video',
        action: 'play',
        label: 'cars',
        value: 1
      })
    end

    it 'tracks event category, action, label, value' do
      expect(Net::HTTP).to have_received(:post_form).with(uri, {
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'event',
        'ec' => 'video',
        'ea' => 'play',
        'el' => 'cars',
        'ev' => 1
      })
    end
  end

  describe "#social" do
    before(:each) do
      tracker.social({
        action: 'like',
        network: 'facebook',
        target: '/blog'
      })
    end

    it 'tracks social action, network, target' do
      expect(Net::HTTP).to have_received(:post_form).with(uri, {
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'social',
        'sa' => 'like',
        'sn' => 'facebook',
        'st' => '/blog'
      })
    end
  end

  describe "#exception" do
    before(:each) do
      tracker.exception({
        description: 'RuntimeException',
        fatal: true,
        non_interactive: true
      })
    end

    it 'tracks exception description and fatality' do
      expect(Net::HTTP).to have_received(:post_form).with(uri, {
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        'ni' => 1,
        't' => 'exception',
        'exd' => 'RuntimeException',
        'exf' => 1
      })
    end
  end

  describe "#timing" do
    before(:each) do
      tracker.timing({
        category: 'view',
        variable: 'runtime',
        label: 'rails',
        time: 1000
      })
    end

    it 'tracks user timing category, variable, label, and time' do
      expect(Net::HTTP).to have_received(:post_form).with(uri, {
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'timing',
        'utc' => 'view',
        'utv' => 'runtime',
        'utl' => 'rails',
        'utt' => 1000 # value in milliseconds
      })
    end
  end

  describe "#timing with block" do
    let(:codez) {stub(:test => true)}

    before(:each) do
      start_at = Time.now
      end_at = start_at + 1 # 1 second

      Time.stubs(:now).returns(start_at).returns(end_at)

      tracker.timing({ category: 'view', variable: 'runtime', label: 'rails' }) do
        codez.test
      end
    end

    it 'tracks user timing category, variable, label, and time' do
      expect(Net::HTTP).to have_received(:post_form).with(uri, {
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'timing',
        'utc' => 'view',
        'utv' => 'runtime',
        'utl' => 'rails',
        'utt' => 1000
      })
    end

    it 'yields to the block' do
      expect(codez).to have_received(:test)
    end
  end

  describe "Transactions" do
    describe "#transaction" do
      let(:transaction_id) {1293281}

      before(:each) do
        tracker.transaction({
          transaction_id: transaction_id,
          affiliation: 'western',
          revenue: 5.99,
          shipping: 12.00,
          tax: 1.40,
          currency: 'USD'
        })
      end

      it 'tracks the transaction values' do
        expect(Net::HTTP).to have_received(:post_form).with(uri, {
          'v' => 1,
          'tid' => 'UA-XXXX-Y',
          'cid' => '555',
          't' => 'transaction',
          'ti' => transaction_id,
          'ta' => 'western',
          'tr' => 5.99,
          'ts' => 12.0,
          'tt' => 1.4,
          'cu' => 'USD'
        })
      end
    end

    describe "#transaction_item" do
      let(:transaction_id) {1293281}

      before(:each) do
        tracker.transaction_item({
          transaction_id: transaction_id,
          name: 'Sofa',
          price: 804.99,
          quantity: 2,
          code: 'afhcka1230',
          variation: 'furniture',
          currency: 'USD'
        })
      end

      it 'tracks the item values' do
        expect(Net::HTTP).to have_received(:post_form).with(uri, {
          'v' => 1,
          'tid' => 'UA-XXXX-Y',
          'cid' => '555',
          't' => 'item',
          'ti' => transaction_id,
          'in' => 'Sofa',
          'ip' => 804.99,
          'iq' => 2,
          'ic' => 'afhcka1230',
          'iv' => 'furniture',
          'cu' => 'USD'
        })
      end
    end
  end

  context "with defaults" do
    before(:each) do
      tracker.hit_defaults[:document_hostname] = 'mysite.com'
    end

    it 'tracks page path and default hostname' do
      tracker.pageview(path: '/foobar')

      expect(Net::HTTP).to have_received(:post_form).with(uri, {
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'dh' => 'mysite.com',
        'dp' => '/foobar'
      })
    end
  end
end

describe Staccato::Tracker, "with multiple adapters" do
  let(:uri) {Staccato.ga_collection_uri}
  let(:net_http_adapter) {Staccato::Adapter::Net::HTTP.new(uri)}
  let(:http_adapter) {Staccato::Adapter::HTTP.new(uri)}
  let(:tracker) {Staccato.tracker('UA-XXXX-Y') do |c|
    c.add_adapter net_http_adapter
    c.add_adapter http_adapter
  end}

  before(:each) do
    net_http_adapter.stubs(:post).returns("Net::HTTP response")
    http_adapter.stubs(:post).returns("HTTP Response")
  end

  it 'returns an array of responses in order of adapter' do
    expect(tracker.pageview(path: '/')).to eq(["Net::HTTP response", "HTTP Response"])
  end
end
