require 'spec_helper'

describe Staccato::Measurement::Promotion do
  let(:uri) {Staccato.ga_collection_uri}
  let(:tracker) {Staccato.tracker('UA-XXXX-Y')}
  let(:response) {stub(:body => '', :status => 201)}

  before(:each) do
    SecureRandom.stubs(:uuid).returns('555')
    Net::HTTP.stubs(:post_form).returns(response)
  end

  context 'a pageview with a transaction' do
    let(:pageview) {
      tracker.build_pageview({
        path: '/search', hostname: 'mystore.com',
        title: 'Search Results'
      })
    }

    let(:measurement_options) {{
      index: 1,
      id: 'PROMO_1234',
      name: 'Summer Sale',
      creative: 'summer_sale_banner',
      position: 'banner_1'
    }}

    before(:each) do
      pageview.add_measurement(:promotion, measurement_options)

      pageview.track!
    end

    it 'tracks the measurement' do
      expect(Net::HTTP).to have_received(:post_form).with(uri, {
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'dh' => 'mystore.com',
        'dp' => '/search',
        'dt' => 'Search Results',
        'promo1id' => 'PROMO_1234',
        'promo1nm' => 'Summer Sale',
        'promo1cr' => 'summer_sale_banner',
        'promo1ps' => 'banner_1'
      })
    end
  end
end
