require 'spec_helper'

describe Staccato::Measurement::ProductImpression do
  let(:uri) {Staccato.tracking_uri}
  let(:tracker) {Staccato.tracker('UA-XXXX-Y')}
  let(:mock_http) {MockHTTP.new(stub(:body => '', :status => 201))}
  let(:request_params) { mock_http.request_params }

  before(:each) do
    SecureRandom.stubs(:uuid).returns('555')
    Net::HTTP.stubs(:new).returns(mock_http)
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
      expect(request_params).to eql(
        'v' => '1',
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
        'il1pi1pr' => '14.6',
        'il1pi1ps' => '1'
      )
    end
  end
end
