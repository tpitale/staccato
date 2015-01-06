require 'spec_helper'

describe Staccato::Pageview do

  let(:tracker) {Staccato.tracker('UA-XXXX-Y', '555')}

  context "with all options" do
    let(:pageview) do
      Staccato::Pageview.new(tracker, {
        :hostname => 'mysite.com',
        :page => '/foobar',
        :title => 'FooBar'
      })
    end

    it 'has a hostname' do
      pageview.hostname.should eq('mysite.com')
    end

    it 'has a page' do
      pageview.page.should eq('/foobar')
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
        :page => '/foobar',
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

    it 'has required params' do
      pageview.params.should eq({
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
      pageview.params.should eq({
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'xid' => 'ac67afa889',
        'xvar' => 'c'
      })
    end
  end

  context "with enhanced e-commerce tracking impressions" do

    let(:pageview) do
      Staccato::Pageview.new(tracker, {
          :hostname => 'mysite.com',
          :page => '/foobar',
          :title => 'FooBar',
          :action => 'play'
        },
        '&il1nm=Search%20Results&il1pi1id=P12345&il1pi1nm=Android%20War&il1pi1ca=Apparel%2FT-S&il1pi1br=Google&il1pi1va=Black&il1pi1ps=1&il1pi1cd1=Member&il2nm=Recommended%20Products&il2pi1nm=Yellow%20T-Shirt&il2pi2nm=Red%20T-Shirt'
      )
    end

    it 'has impression params' do
      pageview.params.should eq({
            'v' => 1,
            'tid' => 'UA-XXXX-Y',
            'cid' => '555',
            't' => 'pageview',
            'dh' => 'mysite.com',
            'dp' => '/foobar',
            'dt' => 'FooBar',
            'il1nm' => 'Search Results',
            'il1pi1br' => 'Google',
            'il1pi1ca' => 'Apparel/T-S',
            'il1pi1cd1' => 'Member',
            'il1pi1id' => 'P12345',
            'il1pi1nm' => 'Android War',
            'il1pi1ps' => '1',
            'il1pi1va' => 'Black',
            'il2nm' => 'Recommended Products',
            'il2pi1nm' => 'Yellow T-Shirt',
            'il2pi2nm' => 'Red T-Shirt'
          })
    end
  end

  context "with enhanced e-commerce measuring actions" do

    let(:pageview) do
      Staccato::Pageview.new(tracker, {
          :hostname => 'mysite.com',
          :page => '/foobar',
          :title => 'FooBar',
          :action => 'play'
        },
        'pa=click&pal=Search%20Results&pr1id=P12345&pr1nm=Android%20Warhol%20T-Shirt&pr1ca=Apparel&pr1br=Google&pr1va=Black&pr1ps=1'
      )
    end

    it 'has measuring action params' do
      pageview.params.should eq({
            'v' => 1,
            'tid' => 'UA-XXXX-Y',
            'cid' => '555',
            't' => 'pageview',
            'dh' => 'mysite.com',
            'dp' => '/foobar',
            'dt' => 'FooBar',
            'pa' => 'click',
            'pal' => 'Search Results',
            'pr1br' => 'Google',
            'pr1ca' => 'Apparel',
            'pr1id' => 'P12345',
            'pr1nm' => 'Android Warhol T-Shirt',
            'pr1ps' => '1',
            'pr1va' => 'Black'
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
      pageview.params.should eq({
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
      pageview.params.should eq({
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

    it 'has custom dimensions' do
      pageview.params.should eq({
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
