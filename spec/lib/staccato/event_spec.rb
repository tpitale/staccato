require 'spec_helper'

describe Staccato::Event do

  let(:tracker) {Staccato.tracker('UA-XXXX-Y', '555')}
  let(:tracker_with_hostname) {Staccato.tracker('UA-XXXX-Y', '555', 'mysite.com')}

  context "with all options" do
    let(:event) do
      Staccato::Event.new(tracker, {
        :category => 'video',
        :action => 'play',
        :label => 'cars',
        :value => 12
      })
    end

    it 'has a category' do
      event.category.should eq('video')
    end

    it 'has a action' do
      event.action.should eq('play')
    end

    it 'has a label' do
      event.label.should eq('cars')
    end

    it 'has a value' do
      event.value.should eq(12)
    end

    it 'has all params' do
      event.params.should eq({
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'event',
        'ec' => 'video',
        'ea' => 'play',
        'el' => 'cars',
        'ev' => 12
      })
    end
  end

  context "with extra options" do
    let(:event) do
      Staccato::Event.new(tracker, {
        :category => 'video',
        :action => 'play',
        :label => 'cars',
        :value => 12,
        :path => '/foobar'
      })
    end

    it 'has all params' do
      event.params.should eq({
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'event',
        'ec' => 'video',
        'ea' => 'play',
        'el' => 'cars',
        'ev' => 12
      })
    end
  end

  context "with no options" do
    def event(tracker)
      Staccato::Event.new(tracker, {})
    end

    it 'has require params' do
      event(tracker).params.should eq({
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'event'
      })
    end

    it 'has require params with hostname' do
      event(tracker_with_hostname).params.should eq({
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'event',
        'dh' => 'mysite.com'
      })
    end
  end
end
