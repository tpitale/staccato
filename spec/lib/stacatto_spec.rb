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

    context 'given a hit' do
      let(:tracker) {Staccato.tracker('UA-XXXX-Y')}

      let(:event) {
        tracker.build_event({
          category: 'email',
          action: 'open',
          label: 'welcome',
          value: 1
        })
      }

      before(:each) do
        SecureRandom.stubs(:uuid).returns("a-uuid")
      end

      it 'turns a hit into a URL string' do
        url = "http://www.google-analytics.com/collect?v=1&tid=UA-XXXX-Y&cid=a-uuid&t=event&ec=email&ea=open&el=welcome&ev=1"

        expect(Staccato.as_url(event)).to eq(url)
      end
    end

  end

end
