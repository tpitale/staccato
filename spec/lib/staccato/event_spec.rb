require 'spec_helper'

describe Staccato::Event do

  let(:tracker) {Staccato.tracker('UA-XXXX-Y', '555')}

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
      expect(event.category).to eq('video')
    end

    it 'has a action' do
      expect(event.action).to eq('play')
    end

    it 'has a label' do
      expect(event.label).to eq('cars')
    end

    it 'has a value' do
      expect(event.value).to eq(12)
    end

    it 'has all params' do
      expect(event.params).to eq({
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
        :hostname => 'mysite.com',
        :path => '/foobar'
      })
    end

    it 'has all params' do
      expect(event.params).to eq({
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
    let(:event) do
      Staccato::Event.new(tracker, {})
    end

    it 'has require params' do
      expect(event.params).to eq({
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'event'
      })
    end
  end
end
