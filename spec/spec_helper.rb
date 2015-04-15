require 'simplecov'
SimpleCov.start

require 'bundler/setup'

require 'rspec'
require 'mocha/api'
require 'bourne'

require File.expand_path('../../lib/staccato', __FILE__)

class MockHTTP
  attr_reader :request_params

  def initialize(response)
    @response = response
  end

  def start
    yield(self)
    @response
  end

  def request(request)
    @request_params = CGI::parse(request.body).inject({}){|acc,k| acc[k.first] = k.last.first; acc }
  end
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.mock_with :mocha

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
