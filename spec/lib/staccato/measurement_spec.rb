require 'spec_helper'

describe Staccato::Measurement do
  it 'looks up the measurement class by key' do
    expect(Staccato::Measurement.lookup(:transaction)).to eq(Staccato::Measurement::Transaction)
  end
end
