module Staccato
  # Extends OpenStruct with `[]` access method when
  #   the current version of ruby does not include it
  class OptionSet < OpenStruct
    extend Forwardable

    unless OpenStruct.instance_methods.include?(:each)
      include Enumerable

      def_delegators :@table, :each
    end

    unless OpenStruct.instance_methods.include?(:[])
      def_delegators :@table, :[], :[]=
    end
  end
end
