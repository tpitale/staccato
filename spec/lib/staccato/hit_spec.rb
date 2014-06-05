require 'spec_helper'

class EmptyHit
  FIELDS = {}

  include Staccato::Hit

  def type; :empty; end
end

describe Staccato::Hit do
  let(:hit_klass) { EmptyHit }
  let(:tracker) { Staccato::NoopTracker.new }

  it 'converts false boolean field values to 0' do
    expect(hit_klass.new(tracker, anonymize_ip: false).params['aip']).to eq(0)
  end

  it 'does not convert integer values in boolean fields' do
    expect(hit_klass.new(tracker, non_interactive: 0).params['ni']).to eq(0)
  end

  it 'converts true boolean field values to 1' do
    expect(hit_klass.new(tracker, java_enabled: true).params['je']).to eq(1)
  end

  it 'rejects nil boolean field values' do
    expect(hit_klass.new(tracker, non_interactive: nil).params.has_key?('ni')).to eq(false)
  end
end
