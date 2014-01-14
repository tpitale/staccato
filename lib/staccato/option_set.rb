module Staccato
  # Extends OpenStruct with `[]` access method when
  #   the current version of ruby does not include it
  class OptionSet < OpenStruct
    unless OpenStruct.instance_methods.include?(:[])
      extend Forwardable

      def_delegators :@table, :[], :[]=
    end
  end
end
