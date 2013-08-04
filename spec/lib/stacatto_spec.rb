require 'spec_helper'

describe Staccato do

  context 'configuring a tracker' do

    let(:tracker) {Staccato.tracker 'UA-XXXX-Y'}

    it 'has an assigned id' do
      tracker.id.should eq('UA-XXXX-Y')
    end

    it 'uses a uuid for the client_id' do
      SecureRandom.stubs(:uuid).returns("a-uuid")

      tracker.client_id.should eq('a-uuid')
    end

  end

end
