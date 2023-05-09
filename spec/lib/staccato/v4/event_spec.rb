# frozen_string_literal: true

require 'staccato/v4'

describe Staccato::V4::Event do

  describe '.event_name' do
    it 'is based on the class name' do
      expect(Staccato::V4::AddPaymentInfo.event_name).to eq(:add_payment_info)
    end
  end

  describe '.recommended_params' do
    it 'returns a list of all recommended event parameters' do
      expect(Staccato::V4::AddToCart.recommended_params).to eq(
        %i[currency value items engagement_time_msec session_id timestamp_micros]
      )
      expect(Staccato::V4::SignUp.recommended_params).to eq(
        %i[method engagement_time_msec session_id timestamp_micros]
      )
    end
  end

  describe '#recommended_params' do
    it 'returns a hash of recommended parameters with their values' do
      event = Staccato::V4::Login.new(method: :password, etc: 1234)
      expect(event.recommended_params).to eq({method: :password})
    end
  end

  describe '#custom_params' do
    it 'returns a hash of custom parameters with their values' do
      event = Staccato::V4::Login.new(method: :password, etc: 1234)
      expect(event.custom_params).to eq({etc: 1234})
    end
  end

  describe '#params' do
    it 'returns a hash of all parameters with their values' do
      event = Staccato::V4::Purchase.new(
        currency: 'USD',
        value: 123.45,
        transaction_id: 'sldkjfs-dlkfsdf',
        etc: 1234
      )
      expect(event.params).to eq({
        currency: 'USD',
        value: 123.45,
        transaction_id: 'sldkjfs-dlkfsdf',
        etc: 1234
      })
    end
  end

  describe '#as_json' do
    it 'returns a hash with the event name and params' do
      event = Staccato::V4::LevelUp.new(
        level: '1-2', character: 'luigi', etc: 'custom'
      )
      expect(event.as_json).to eq({
        name: :level_up,
        params: {
          level: '1-2', character: 'luigi', etc: 'custom'
        }
      })
    end

    it 'returns simple array of hashes for items' do
      event = Staccato::V4::AddToCart.new(
        currency: 'USD', value: 123_123.12, items: [
          Staccato::V4::Item.new(item_id: 'SLKDFJ', index: 12, quantity: 33),
          Staccato::V4::Item.new(item_id: 'SLKDFJ', index: 45, quantity: 11),
          Staccato::V4::Item.new(item_id: 'SLKDFJ', index: 78, quantity: 99)
        ]
      )
      expect(event.as_json).to eq({
        name: :add_to_cart,
        params: {
          currency: 'USD', value: 123_123.12, items: [
            {item_id: 'SLKDFJ', index: 12, quantity: 33},
            {item_id: 'SLKDFJ', index: 45, quantity: 11},
            {item_id: 'SLKDFJ', index: 78, quantity: 99}
          ]
        }
      })
    end
  end

end
