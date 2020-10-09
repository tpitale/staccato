require 'spec_helper'

describe Staccato::Tracker do

  let(:tracker) {Staccato.tracker('UA-XXXX-Y')}

  context "#pageview" do
    let(:pageview) {Staccato::Pageview.new(tracker, {})}

    before(:each) do
      allow(pageview).to receive(:track!)
      allow(Staccato::Pageview).to receive(:new).and_return(pageview)

      tracker.pageview(path: '/foobar')
    end

    it "creates a new Pageview" do
      expect(Staccato::Pageview).to have_received(:new).with(tracker, path: '/foobar')
    end

    it "tracks on the Pageview" do
      expect(pageview).to have_received(:track!)
    end
  end

  context "#event" do
    let(:event) {Staccato::Event.new(tracker, {})}

    before(:each) do
      allow(event).to receive(:track!)
      allow(Staccato::Event).to receive(:new).and_return(event)

      tracker.event(category: 'video', action: 'play')
    end

    it "creates a new Event" do
      expect(Staccato::Event).to have_received(:new).with(tracker, category: 'video', action: 'play')
    end

    it "tracks on the Event" do
      expect(event).to have_received(:track!)
    end
  end

end

require 'staccato/adapter/batch'

describe Staccato::Tracker, "with a batch adapter" do
  let(:tracker) {Staccato.tracker('UA-XXXX-Y') {|c| c.adapter = batch_adapter}}

  before(:each) do
    allow(SecureRandom).to receive(:uuid).and_return(555)
  end

  context "with a small queue size" do
    let(:batch_adapter) {Staccato::Adapter::Batch.new(Staccato.default_adapter, size: 2, flush_timeout: 100)}
    let(:adapter) {batch_adapter.adapter}

    before(:each) do
      allow(adapter).to receive(:post_body)
    end

    it 'flushes when the queue is full' do
      tracker.event(catgeory: 'video', action: 'play')
      tracker.event(catgeory: 'video', action: 'pause')

      # timing fun, waiting for flush thread to wake up
      sleep(0.2)

      expect(adapter).to have_received(:post_body).with("v=1&tid=UA-XXXX-Y&cid=555&t=event&ea=play\nv=1&tid=UA-XXXX-Y&cid=555&t=event&ea=pause")

      batch_adapter.clear(final: true)
    end
  end

  context "with a small flush timeout" do
    let(:batch_adapter) {Staccato::Adapter::Batch.new(Staccato.default_adapter, size: 20, flush_timeout: 0.1)}
    let(:adapter) {batch_adapter.adapter}

    before(:each) do
      allow(adapter).to receive(:post_body)
    end

    it 'flushes when timeout has passed' do
      tracker.event(catgeory: 'video', action: 'play')

      # timing fun, waiting for flush_timeout
      sleep(0.5)

      expect(adapter).to have_received(:post_body).with("v=1&tid=UA-XXXX-Y&cid=555&t=event&ea=play")

      batch_adapter.clear(final: true)
    end
  end
end
