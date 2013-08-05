module Staccato
  class OptionSet < OpenStruct
    unless OpenStruct.instance_methods.include?(:[])
      extend Forwardable

      def_delegators :@table, :[], :[]=
    end
  end
end
