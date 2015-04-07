# Measurement class for when we need a standin
class NullMeasurement
  # Measurement fields for a noop
  FIELDS = {}.freeze

  # Initialize a noop measurement standin
  def initialize(*); end

  # Params for this noop measurement
  # @return [Hash]
  def params(*); {}; end
end
