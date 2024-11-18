require_relative 'base'

module RailsFlags
  module Adapters
    class MemoryAdapter < Base
      def initialize
        @features = {}
      end

      def read(flag)
        @features[flag.to_sym]
      end

      def write(flag, value)
        @features[flag.to_sym] = value
      end

      def delete(flag)
        @features.delete(flag.to_sym)
      end

      def all
        @features.dup
      end

      def clear
        @features.clear
      end
    end
  end
end
