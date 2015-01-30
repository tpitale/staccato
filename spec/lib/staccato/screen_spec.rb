require 'spec_helper'

describe Staccato::Screen do

  let(:tracker) { Staccato.tracker('UA-XXXX-Y', '555') }

  context 'with all options' do
    let(:screen) do
      Staccato::Screen.new(tracker, {
          name: 'funTimes',
          version: '4.2.0',
          id: 'com.foo.App',
          installer_id: 'com.android.vending',
          content_description: 'Home'
        })
    end
    
    it 'should have a name' do
      expect(screen.name).to eq('funTimes')
    end   
    
    it 'should have a version' do
      expect(screen.version).to eq('4.2.0')
    end  
    
    it 'should have an id' do
      expect(screen.id).to eq('com.foo.App')
    end   
    
    it 'should have an installer_id' do
      expect(screen.installer_id).to eq('com.android.vending')
    end   
     
    it 'should have a content_description' do
      expect(screen.content_description).to eq('Home')
    end

    it 'has all params' do
      expect(screen.params).to eq({
            'v' => 1,
            'tid' => 'UA-XXXX-Y',
            'cid' => '555',
            't' => 'screenview',
            'an' => 'funTimes',
            'av' => '4.2.0',
            'aid' => 'com.foo.App',
            'aiid' => 'com.android.vending',
            'cd' => 'Home'
          })
    end
  end

  context "with extra options" do
    let(:screen) do
      Staccato::Screen.new(tracker, {
          name: 'funTimes',
          version: '4.2.0',
          id: 'com.foo.App',
          installer_id: 'com.android.vending',
          content_description: 'Home',
          :hostname => 'mysite.com',
          :path => '/foobar'
        })
    end

    it 'has all params' do
      expect(screen.params).to eq({
            'v' => 1,
            'tid' => 'UA-XXXX-Y',
            'cid' => '555',
            't' => 'screenview',
            'an' => 'funTimes',
            'av' => '4.2.0',
            'aid' => 'com.foo.App',
            'aiid' => 'com.android.vending',
            'cd' => 'Home'
          })
    end
  end

  context 'with no options' do
    let(:screen) do
      Staccato::Screen.new(tracker, {})
    end

    it 'has require params' do
      expect(screen.params).to eq({
            'v' => 1,
            'tid' => 'UA-XXXX-Y',
            'cid' => '555',
            't' => 'screenview'
          })
    end
  end
end
