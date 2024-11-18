require_relative 'adapters/base'
require_relative 'adapters/redis_adapter'

module RailsFlags
  class Configuration
    attr_reader :adapter

    def initialize(adapter: nil)
      @adapter = adapter
      @features = {}
      load_from_adapter if adapter
    end

    def register(name, enabled: false, description: nil)
      validate_flag_name!(name)
      data = {
        enabled: enabled,
        description: description,
        created_at: Time.now
      }

      @features[name.to_sym] = data
      @adapter&.write(name.to_sym, data)
      data
    end

    def enabled?(flag)
      validate_flag_exists!(flag)
      if @adapter
        data = @adapter.read(flag.to_sym)
        data ? data[:enabled] == true : false
      else
        @features.dig(flag.to_sym, :enabled) == true
      end
    end

    def enable(flag)
      validate_flag_exists!(flag)
      data = (@adapter&.read(flag.to_sym) || @features[flag.to_sym]).dup
      data[:enabled] = true
      @features[flag.to_sym] = data
      @adapter&.write(flag.to_sym, data)
    end

    def disable(flag)
      validate_flag_exists!(flag)
      data = (@adapter&.read(flag.to_sym) || @features[flag.to_sym]).dup
      data[:enabled] = false
      @features[flag.to_sym] = data
      @adapter&.write(flag.to_sym, data)
    end

    def registered?(flag)
      @features.key?(flag.to_sym) || (@adapter&.read(flag.to_sym) ? true : false)
    end

    def all_flags
      if @adapter
        @adapter.all
      else
        @features.transform_values { |v| v[:enabled] }
      end
    end

    def use_adapter(adapter)
      @adapter = adapter
      load_from_adapter
    end

    private

    def load_from_adapter
      return unless @adapter
      @features = @adapter.all
    end

    def validate_flag_name!(name)
      raise ArgumentError, "Flag name must be a String or Symbol" unless name.is_a?(String) || name.is_a?(Symbol)
      raise ArgumentError, "Flag name cannot be empty" if name.to_s.strip.empty?
    end

    def validate_flag_exists!(flag)
      raise KeyError, "Flag '#{flag}' is not registered" unless registered?(flag)
    end
  end
end
