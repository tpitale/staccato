require 'spec_helper'

describe Staccato do

  context 'configuring a tracker' do

    let(:tracker) {Staccato.tracker 'UA-XXXX-Y'}

    it 'has an assigned id' do
      expect(tracker.id).to eq('UA-XXXX-Y')
    end

    it 'uses a uuid for the client_id' do
      SecureRandom.stubs(:uuid).returns("a-uuid")

      expect(tracker.client_id).to eq('a-uuid')
    end

  end

end
