require 'spec_helper'

describe Staccato::Measurement::ProductImpression do
  let(:uri) {Staccato.ga_collection_uri}
  let(:tracker) {Staccato.tracker('UA-XXXX-Y')}
  let(:response) {stub(:body => '', :status => 201)}

  let(:pageview) {
    tracker.build_pageview({
      path: '/home',
      hostname: 'mystore.com',
      title: 'Home Page'
    })
  }

  let(:impression_list_options) {{
    index: 1,
    name: 'Search Results'
  }}

  let(:product_impression_options) {{
    index: 1,
    list_index: 1, # match the impression_list above
    id: 'P12345',
    name: 'T-Shirt',
    category: 'Apparel',
    brand: 'Your Brand',
    variant: 'Purple',
    position: 1,
    price: 14.60
  }}

  let(:product_impression) { Staccato::Measurement::ProductImpression.new(product_impression_options) }

  before(:each) do
    SecureRandom.stubs(:uuid).returns('555')
    Net::HTTP.stubs(:post_form).returns(response)
  end

  context 'a pageview with an List Impression' do

    before(:each) do
      pageview.add_measurement(:impression_list, impression_list_options)
      pageview.add_measurement(:product_impression, product_impression_options)

      pageview.track!
    end

    it 'tracks the measurement' do
      expect(Net::HTTP).to have_received(:post_form).with(uri, {
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'dh' => 'mystore.com',
        'dp' => '/home',
        'dt' => 'Home Page',
        'il1nm' => 'Search Results',
        'il1pi1id' => 'P12345',
        'il1pi1nm' => 'T-Shirt',
        'il1pi1br' => 'Your Brand',
        'il1pi1ca' => 'Apparel',
        'il1pi1va' => 'Purple',
        'il1pi1pr' => 14.60,
        'il1pi1ps' => 1
      })
    end
  end

  context 'with some custom dimensions' do

    before(:each) do
      pageview.add_measurement(:impression_list, impression_list_options)
      product_impression.add_custom_dimension(1, 'Apple')
      product_impression.add_custom_dimension(5, 'Samsung')
      pageview.add_measurement(:product_impression, product_impression)

      pageview.track!
    end

    it 'has custom dimensions data' do
      expect(Net::HTTP).to have_received(:post_form).with(uri, {
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'dh' => 'mystore.com',
        'dp' => '/home',
        'dt' => 'Home Page',
        'il1nm' => 'Search Results',
        'il1pi1id' => 'P12345',
        'il1pi1nm' => 'T-Shirt',
        'il1pi1br' => 'Your Brand',
        'il1pi1ca' => 'Apparel',
        'il1pi1va' => 'Purple',
        'il1pi1pr' => 14.60,
        'il1pi1ps' => 1,
        'il1pi1cd1' => 'Apple',
        'il1pi1cd5' => 'Samsung'
      })
    end
  end

  context 'with some custom metrics' do

    before(:each) do
      pageview.add_measurement(:impression_list, impression_list_options)
      product_impression.add_custom_metric(1, 43.20)
      product_impression.add_custom_metric(3, 8)
      pageview.add_measurement(:product_impression, product_impression)

      pageview.track!
    end

    it 'has custom metric data' do
      expect(Net::HTTP).to have_received(:post_form).with(uri, {
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'dh' => 'mystore.com',
        'dp' => '/home',
        'dt' => 'Home Page',
        'il1nm' => 'Search Results',
        'il1pi1id' => 'P12345',
        'il1pi1nm' => 'T-Shirt',
        'il1pi1br' => 'Your Brand',
        'il1pi1ca' => 'Apparel',
        'il1pi1va' => 'Purple',
        'il1pi1pr' => 14.60,
        'il1pi1ps' => 1,
        'il1pi1cm1' => 43.20,
        'il1pi1cm3' => 8
      })
    end
  end

end
