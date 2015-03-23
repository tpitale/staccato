require 'spec_helper'

describe Staccato::Measurement::Product do
  let(:uri) {Staccato.tracking_uri}
  let(:tracker) {Staccato.tracker('UA-XXXX-Y')}
  let(:response) {stub(:body => '', :status => 201)}

  before(:each) do
    SecureRandom.stubs(:uuid).returns('555')
    Net::HTTP.stubs(:post_form).returns(response)
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
      Net::HTTP.should have_received(:post_form).with(uri, {
        'v' => 1,
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
        'pr1qt' => 2,
        'pr1ps' => 1,
        'pr1pr' => 14.60,
        'pr1cc' => 'ILUVTEES'
      })
    end
  end
end
