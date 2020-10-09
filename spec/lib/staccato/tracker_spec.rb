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
