require 'spec_helper'

describe Staccato::Measurement::Product do
  let(:uri) {Staccato.tracking_uri}
  let(:tracker) {Staccato.tracker('UA-XXXX-Y')}
  let(:mock_http) {MockHTTP.new(stub(:body => '', :status => 201))}
  let(:request_params) { mock_http.request_params }

  before(:each) do
    SecureRandom.stubs(:uuid).returns('555')
    Net::HTTP.stubs(:new).returns(mock_http)
  end

  context 'a pageview with a transaction' do
    let(:event) {
      tracker.build_event({
        category: 'search',
        action: 'click',
        label: 'results',
        product_action: 'click',
        product_action_list: 'Search Results'
      })
    }

    let(:measurment_options) {{
      index: 1,
      id: 'P12345',
      name: 'T-Shirt',
      category: 'Apparel',
      brand: 'Your Brand',
      variant: 'Purple',
      quantity: 2,
      position: 1,
      price: 14.60,
      coupon_code: 'ILUVTEES'
    }}

    before(:each) do
      event.add_measurement(:product, measurment_options)

      event.track!
    end

    it 'tracks the measurment' do
      expect(request_params).to eql(
        'v' => '1',
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'event',
        'ec' => 'search',
        'ea' => 'click',
        'el' => 'results',
        'pa' => 'click',
        'pal' => 'Search Results',
        'pr1id' => 'P12345',
        'pr1nm' => 'T-Shirt',
        'pr1ca' => 'Apparel',
        'pr1br' => 'Your Brand',
        'pr1va' => 'Purple',
        'pr1qt' => '2',
        'pr1ps' => '1',
        'pr1pr' => '14.6',
        'pr1cc' => 'ILUVTEES'
      )
    end
  end
end
