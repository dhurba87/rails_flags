module RailsFlags
  module Adapters
    class Base
      def read(flag)
        raise NotImplementedError
      end

      def write(flag, value)
        raise NotImplementedError
      end

      def delete(flag)
        raise NotImplementedError
      end

      def all
        raise NotImplementedError
      end

      def clear
        raise NotImplementedError
      end
    end
  end
end
