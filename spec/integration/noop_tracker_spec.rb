require 'spec_helper'

describe Staccato::NoopTracker do
  let(:uri) {Staccato.ga_collection_uri}
  let(:tracker) {Staccato.tracker(nil)}
  let(:response) {stub(:body => '', :status => 201)}

  before(:each) do
    SecureRandom.stubs(:uuid).returns('555')
    Net::HTTP.stubs(:post_form).returns(response)
  end

  describe "#pageview" do
    before(:each) do
      tracker.pageview(path: '/foobar', title: 'FooBar', hostname: 'mysite.com')
    end

    it 'does not track page path and page title' do
      expect(Net::HTTP).to have_received(:post_form).never
    end
  end

  describe 'settings' do
    it 'has an adapter' do
      expect(tracker.respond_to?(:adapter=)).to eq(true)
    end

    it 'has hit defaults' do
      expect(tracker.hit_defaults).to eq({})

      tracker.hit_defaults[:document_hostname] = 'mysite.com'

      expect(tracker.hit_defaults[:document_hostname]).to eq 'mysite.com'
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

    it 'does not track event category, action, label, value' do
      expect(Net::HTTP).to have_received(:post_form).never
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

    it 'does not track social action, network, target' do
      expect(Net::HTTP).to have_received(:post_form).never
    end
  end

  describe "#exception" do
    before(:each) do
      tracker.exception({
        description: 'RuntimeException',
        fatal: true
      })
    end

    it 'does not track exception description and fatality' do
      expect(Net::HTTP).to have_received(:post_form).never
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

    it 'does not track user timing category, variable, label, and time' do
      expect(Net::HTTP).to have_received(:post_form).never
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

    it 'does not track user timing category, variable, label, and time' do
      expect(Net::HTTP).to have_received(:post_form).never
    end

    it 'yields to the block' do
      expect(codez).to have_received(:test)
    end
  end

  describe "#track" do
    before(:each) do
      tracker.track
    end

    it 'does not send a post request' do
      expect(Net::HTTP).to have_received(:post_form).never
    end
  end
end
