require 'spec_helper'

describe Staccato::Measurement::Transaction do
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
        path: '/receipt', hostname: 'mystore.com',
        title: 'Your Receipt', product_action: 'purchase'
      })
    }

    let(:measurment_options) {{
      transaction_id: 'T12345',
      affiliation: 'Your Store',
      revenue: 37.39,
      tax: 2.85,
      shipping: 5.34,
      currency: 'USD',
      coupon_code: 'SUMMERSALE'
    }}

    before(:each) do
      pageview.add_measurement(:transaction, measurment_options)

      pageview.track!
    end

    it 'tracks the measurment' do
      expect(request_params).to eql(
        'v' => '1',
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'dh' => 'mystore.com',
        'dp' => '/receipt',
        'dt' => 'Your Receipt',
        'pa' => 'purchase',
        'ti' => 'T12345',
        'ta' => 'Your Store',
        'tr' => '37.39',
        'ts' => '5.34',
        'tt' => '2.85',
        'cu' => 'USD',
        'tcc' => 'SUMMERSALE'
      )
    end
  end
end
