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
        :hostname => 'mysite.com',
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
    let(:event) do
      Staccato::Event.new(tracker, {})
    end

    it 'has require params' do
      event.params.should eq({
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'event'
      })
    end
  end
end
