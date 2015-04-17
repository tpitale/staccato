require 'spec_helper'

describe Staccato::Measurement::CheckoutOption do
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
        path: '/checkout', hostname: 'mystore.com',
        title: 'Complete Your Checkout', product_action: 'checkout_option'
      })
    }

    let(:measurement_options) {{
      step: 1,
      step_options: 'Visa'
    }}

    before(:each) do
      pageview.add_measurement(:checkout_option, measurement_options)

      pageview.track!
    end

    it 'tracks the measurement' do
      expect(Net::HTTP).to have_received(:post_form).with(uri, {
        'v' => 1,
        'tid' => 'UA-XXXX-Y',
        'cid' => '555',
        't' => 'pageview',
        'dh' => 'mystore.com',
        'dp' => '/checkout',
        'dt' => 'Complete Your Checkout',
        'pa' => 'checkout_option',
        'cos' => 1,
        'col' => 'Visa'
      })
    end
  end
end
