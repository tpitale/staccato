require 'spec_helper'

describe Staccato::Measurement::Product do
  let(:uri) {Staccato.ga_collection_uri}
  let(:tracker) {Staccato.tracker('UA-XXXX-Y')}
  let(:response) {stub(:body => '', :status => 201)}

  let(:event) {
    tracker.build_event({
      category: 'search',
      action: 'click',
      label: 'results',
      product_action: 'click',
      product_action_list: 'Search Results'
    })
  }

  before(:each) do
    SecureRandom.stubs(:uuid).returns('555')
    Net::HTTP.stubs(:post_form).returns(response)
  end

  context 'a pageview with an event' do

    let(:measurement_options) {{
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

    before do
      event.add_measurement(:product, measurement_options)
      event.track!
    end

    it 'tracks the measurement' do
      expect(Net::HTTP).to have_received(:post_form).with(uri, {
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

  context "with some custom dimensions" do
    let(:measurement_options) {{
      index: 1,
      id: 'P12345',
      name: 'T-Shirt',
      category: 'Apparel',
      brand: 'Your Brand',
      variant: 'Purple',
      quantity: 2,
      position: 1,
      price: 14.60,
      coupon_code: 'ILUVTEES',
      custom_dimensions:[
        [1, 'Apple'],
        [5, 'Samsung']
      ]
    }}

    before(:each) do
      event.add_measurement(:product, measurement_options)
      event.track!
    end

    it 'has custom dimensions' do
      expect(Net::HTTP).to have_received(:post_form).with(uri, {
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
        'pr1cc' => 'ILUVTEES',
        'pr1cd1' => 'Apple',
        'pr1cd5' => 'Samsung'
      })
    end
  end

  context "with some custom metrics" do
    let(:measurement_options) {{
      index: 1,
      id: 'P12345',
      name: 'T-Shirt',
      category: 'Apparel',
      brand: 'Your Brand',
      variant: 'Purple',
      quantity: 2,
      position: 1,
      price: 14.60,
      coupon_code: 'ILUVTEES',
      custom_metrics:[
        [1, 78],
        [3, 30.40]
      ]
    }}

    before do
      event.add_measurement(:product, measurement_options)

      event.track!
    end

    it 'has custom metrics' do
      expect(Net::HTTP).to have_received(:post_form).with(uri, {
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
        'pr1cc' => 'ILUVTEES',
        'pr1cm1' => 78,
        'pr1cm3' => 30.40
      })
    end
  end
end
