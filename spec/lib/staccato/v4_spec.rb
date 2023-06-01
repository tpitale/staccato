# frozen_string_literal: true

require 'staccato/v4'
require_relative 'v4/shared_examples'

describe Staccato::V4 do

  describe '.collection_uri' do
    include_examples 'V4.collection_uri'
  end

  describe '.validation_uri' do
    include_examples 'V4.validation_uri'
  end

  describe '.default_adapter_class' do
    include_examples 'default_adapter_class'
  end

  describe '.validation_adapter_class' do
    include_examples 'validation_adapter_class'
  end

  describe '.default_adapter' do
    include_examples 'V4.default_adapter'
  end

  describe '.validation_adapter' do
    include_examples 'V4.validation_adapter'
  end

  describe '.timestamp_micros' do
    it 'returns the UNIX timestamp in microseconds' do
      time = Time.now
      expect(Staccato::V4.timestamp_micros(time))
        .to eq time.to_f.*(1_000_000).to_i
    end
  end

end
