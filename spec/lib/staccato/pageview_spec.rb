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
      pageview.hostname.should eq('mysite.com')
    end

    it 'has a path' do
      pageview.path.should eq('/foobar')
    end

    it 'has a title' do
      pageview.title.should eq('FooBar')
    end

    it 'has all params' do
      pageview.params.should eq({
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
      pageview.params.should eq({
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

    it 'has require params' do
      pageview.params.should eq({
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview'
      })
    end
  end
end
