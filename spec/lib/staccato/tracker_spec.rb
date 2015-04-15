require 'spec_helper'

describe Staccato::Tracker do

  let(:tracker) {Staccato.tracker('UA-XXXX-Y')}

  context "#pageview" do
    let(:pageview) {Staccato::Pageview.new(tracker, {})}

    before(:each) do
      pageview.stubs(:track!)
      Staccato::Pageview.stubs(:new).returns(pageview)

      tracker.pageview(path: '/foobar')
    end

    it "creates a new Pageview" do
      Staccato::Pageview.should have_received(:new).with(tracker, path: '/foobar')
    end

    it "tracks on the Pageview" do
      pageview.should have_received(:track!)
    end
  end

  context "#event" do
    let(:event) {Staccato::Event.new(tracker, {})}

    before(:each) do
      event.stubs(:track!)
      Staccato::Event.stubs(:new).returns(event)

      tracker.event(category: 'video', action: 'play')
    end

    it "creates a new Event" do
      Staccato::Event.should have_received(:new).with(tracker, category: 'video', action: 'play')
    end

    it "tracks on the Event" do
      event.should have_received(:track!)
    end
  end

  context "set http_read_timeout" do
    it "default http_read_timeout is nil" do
      expect(tracker.http_read_timeout).to eql(nil)
    end

    it "can set http_read_timeout" do
      tracker.http_read_timeout = 1
      expect(tracker.http_read_timeout).to eql(1)
    end
  end

end
