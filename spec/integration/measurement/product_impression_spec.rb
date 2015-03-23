require 'spec_helper'

describe Staccato::Measurement::ProductImpression do
  let(:uri) {Staccato.tracking_uri}
  let(:tracker) {Staccato.tracker('UA-XXXX-Y')}
  let(:response) {stub(:body => '', :status => 201)}

  before(:each) do
    SecureRandom.stubs(:uuid).returns('555')
    Net::HTTP.stubs(:post_form).returns(response)
  end

  context 'a pageview with a transaction' do
    let(:pageview) {
      tracker.build_pageview({
        path: '/home',
        hostname: 'mystore.com',
        title: 'Home Page'
      })
    }

    let(:measurment_options) {{
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

    before(:each) do
      pageview.add_measurement(:impression_list, index: 1, name: 'Search Results')
      pageview.add_measurement(:product_impression, measurment_options)

      pageview.track!
    end

    it 'tracks the measurment' do
      Net::HTTP.should have_received(:post_form).with(uri, {
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'dh' => 'mystore.com',
        'dp' => '/home',
        'dt' => 'Home Page',
        'il1nm' => 'Search Results',
        'il1pr1id' => 'P12345',
        'il1pr1nm' => 'T-Shirt',
        'il1pr1br' => 'Your Brand',
        'il1pr1ca' => 'Apparel',
        'il1pr1va' => 'Purple',
        'il1pr1pr' => 14.60,
        'il1pr1ps' => 1
      })
    end
  end
end
