require 'spec_helper'

describe Staccato::Exception do
  let(:tracker) { Staccato::NoopTracker.new }

  it 'converts false fatal boolean field values to 0' do
    expect(Staccato::Exception.new(tracker, fatal: false).params['exf']).to eq(0)
  end

  it 'does not convert fatal field integer values' do
    expect(Staccato::Exception.new(tracker, fatal: 0).params['exf']).to eq(0)
  end

  it 'converts true fatal boolean field values to 1' do
    expect(Staccato::Exception.new(tracker, fatal: true).params['exf']).to eq(1)
  end

  it 'rejects nil fatal boolean field values' do
    expect(Staccato::Exception.new(tracker, fatal: nil).params.has_key?('exf')).to eq(false)
  end
end
