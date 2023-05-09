# frozen_string_literal: true

RSpec.shared_examples 'v4 Measurement Protocol URI' do
  it { is_expected.to be_a_kind_of(URI) }
  it { is_expected.to be_an_instance_of(URI::HTTPS) }

  it 'uses the Google Analytics server' do
    expect(subject.host).to eq('www.google-analytics.com')
  end

  it 'ends with /mp/collect' do
    expect(subject.path).to end_with('/mp/collect')
    expect(subject.to_s).to end_with('/mp/collect')
  end

  it 'has no query string' do
    expect(subject.query).to be_nil
  end
end

RSpec.shared_examples 'default_adapter_class' do
  subject(:adapter_class) { described_class.default_adapter_class }

  it { is_expected.to equal(Staccato::Adapter::Net::HTTP) }
end

RSpec.shared_examples 'validation_adapter_class' do
  subject(:adapter_class) { described_class.validation_adapter_class }

  it { is_expected.to equal(Staccato::Adapter::Validate) }
end

RSpec.shared_examples 'V4.collection_uri' do
  subject(:uri) { described_class.collection_uri }

  include_examples 'v4 Measurement Protocol URI'

  it 'uses /mp/collect as its path' do
    expect(uri.path).to eq('/mp/collect')
  end
end

RSpec.shared_examples 'V4.validation_uri' do
  subject(:uri) { described_class.validation_uri }

  include_examples 'v4 Measurement Protocol URI'

  it 'uses /debug/mp/collect as its path' do
    expect(uri.path).to eq('/debug/mp/collect')
  end
end

RSpec.shared_examples 'V4.default_adapter' do
  subject(:adapter) { described_class.default_adapter }

  it { is_expected.to be_an_instance_of(Staccato::Adapter::Net::HTTP) }

  it 'is a singleton' do
    expect(adapter).to equal(described_class.default_adapter)
  end

  it 'uses the URI for Google Analytics v4 Measurement Protocol' do
    expect(adapter.uri).to eq(Staccato::V4::AdapterDefaults::COLLECTION_URI)
  end
end

RSpec.shared_examples 'V4.validation_adapter' do
  subject(:adapter) { described_class.validation_adapter }

  it { is_expected.to be_an_instance_of(Staccato::Adapter::Validate) }

  it 'is a singleton' do
    expect(adapter).to equal(described_class.validation_adapter)
  end

  it 'uses the URI for Google Analytics v4 Measurement Protocol Validation Server' do
    expect(adapter.uri).to eq(Staccato::V4::AdapterDefaults::VALIDATION_URI)
  end

  it 'wraps an instance of default_adapter_class' do
    expect(adapter.adapter)
      .to be_an_instance_of(described_class.default_adapter_class)
    expect(adapter.adapter.uri).to eq(adapter.uri)
  end
end
