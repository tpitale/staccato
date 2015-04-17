require 'spec_helper'

describe Staccato::Pageview do

  let(:tracker) {Staccato.tracker('UA-XXXX-Y', '555')}

  context "with all options" do
    let(:pageview) do
      Staccato::Pageview.new(tracker, {
        :hostname => 'mysite.com',
        :path => '/foobar',
        :title => 'FooBar'
      })
    end

    it 'has a hostname' do
      expect(pageview.hostname).to eq('mysite.com')
    end

    it 'has a path' do
      expect(pageview.path).to eq('/foobar')
    end

    it 'has a title' do
      expect(pageview.title).to eq('FooBar')
    end

    it 'has all params' do
      expect(pageview.params).to eq({
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

  context "with extra options" do
    let(:pageview) do
      Staccato::Pageview.new(tracker, {
        :hostname => 'mysite.com',
        :path => '/foobar',
        :title => 'FooBar',
        :action => 'play'
      })
    end

    it 'has all params' do
      expect(pageview.params).to eq({
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

  context "with no options" do
    let(:pageview) do
      Staccato::Pageview.new(tracker, {})
    end

    it 'has required params' do
      expect(pageview.params).to eq({
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview'
      })
    end
  end

  context "with experiment_* options" do
    let(:pageview) do
      Staccato::Pageview.new(tracker, {
        experiment_id: 'ac67afa889',
        experiment_variant: 'c'
      })
    end

    it 'has experiment id and variant' do
      expect(pageview.params).to eq({
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'xid' => 'ac67afa889',
        'xvar' => 'c'
      })
    end
  end

  context "with session control" do
    let(:pageview) do
      Staccato::Pageview.new(tracker, {
        session_start: true
      })
    end

    it 'has session control param' do
      expect(pageview.params).to eq({
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'sc' => 'start'
      })
    end
  end

  context "with some custom dimensions" do
    let(:pageview) do
      Staccato::Pageview.new(tracker)
    end

    before(:each) do
      pageview.add_custom_dimension(19, 'Apple')
      pageview.add_custom_dimension(8, 'Samsung')
    end

    it 'has custom dimensions' do
      expect(pageview.params).to eq({
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'cd19' => 'Apple',
        'cd8' => 'Samsung'
      })
    end
  end

  context "with some custom metrics" do
    let(:pageview) do
      Staccato::Pageview.new(tracker)
    end

    before(:each) do
      pageview.add_custom_metric(12, 42)
      pageview.add_custom_metric(1, 11)
    end

    it 'has custom metrics' do
      expect(pageview.params).to eq({
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'cm12' => 42,
        'cm1' => 11
      })
    end
  end
end
