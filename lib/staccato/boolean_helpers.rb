# Collection of methods for converting to
#   google's boolean integers from ruby's booleans
module BooleanHelpers
  # Convert each boolean in the hash to integer
  #   if it is a boolean field
  # @param hash [Hash]
  # @return [Hash]
  def convert_booleans(hash)
    hash.each_pair.with_object({}, &method(:convert_boolean))
  end

  # Method to convert a single field from bool to int
  # @param hash [#[]=] the collector object
  def convert_boolean((k,v), hash)
    hash[k] = boolean_field?(k) ? integer_for(v) : v
  end

  # Is this key one of the boolean fields
  # @param key [Symbol] field key
  # @return [Boolean]
  def boolean_field?(key)
    boolean_fields.include?(key)
  end

  # Convert a value to appropriate int
  # @param value [nil, true, false, Integer]
  # @return [nil, Integer]
  def integer_for(value)
    case value
    when Integer
      value
    when TrueClass
      1
    when FalseClass
      0
    when NilClass
      nil
    end
  end
end
