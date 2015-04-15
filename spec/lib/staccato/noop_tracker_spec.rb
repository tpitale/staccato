require 'spec_helper'

describe Staccato::NoopTracker do

  let(:tracker) {Staccato.tracker(nil) }

  context "set http_read_timeout" do
    it "default http_read_timeout is nil" do
      expect(tracker.http_read_timeout).to eql(nil)
    end

    it "can set http_read_timeout" do
      tracker.http_read_timeout = 1
      expect(tracker.http_read_timeout).to eql(1)
    end
  end

  context "set http_open_timeout" do
    it "default http_open_timeout is nil" do
      expect(tracker.http_open_timeout).to eql(nil)
    end

    it "can set http_open_timeout" do
      tracker.http_open_timeout = 1
      expect(tracker.http_open_timeout).to eql(1)
    end
  end
end
