require 'spec_helper'

describe Staccato::Measurement::CheckoutOption do
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
        path: '/checkout', hostname: 'mystore.com',
        title: 'Complete Your Checkout', product_action: 'checkout_option'
      })
    }

    let(:measurment_options) {{
      step: 1,
      step_options: 'Visa'
    }}

    before(:each) do
      pageview.add_measurement(:checkout_option, measurment_options)

      pageview.track!
    end

    it 'tracks the measurment' do
      expect(request_params).to eql(
        'v' => '1',
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'dh' => 'mystore.com',
        'dp' => '/checkout',
        'dt' => 'Complete Your Checkout',
        'pa' => 'checkout_option',
        'cos' => '1',
        'col' => 'Visa'
      )
    end
  end
end
