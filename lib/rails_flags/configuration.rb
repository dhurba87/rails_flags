require_relative "adapters/base"
require_relative "adapters/redis_adapter"
require_relative "adapters/memory_adapter"

module RailsFlags
  class Configuration
    attr_accessor :adapter

    def initialize(adapter: nil)
      @adapter = adapter || Adapters::MemoryAdapter.new
    end

    def register(name, enabled: false, description: nil)
      validate_flag_name!(name)
      data = {
        enabled: enabled,
        description: description,
        created_at: Time.now
      }

      @adapter.write(name.to_sym, data)
      data
    end

    def enabled?(flag)
      validate_flag_exists!(flag)
      data = @adapter.read(flag.to_sym)
      data ? data[:enabled] == true : false
    end

    def enable(flag)
      validate_flag_exists!(flag)
      data = @adapter.read(flag.to_sym).dup
      data[:enabled] = true
      @adapter.write(flag.to_sym, data)
    end

    def disable(flag)
      validate_flag_exists!(flag)
      data = @adapter.read(flag.to_sym).dup
      data[:enabled] = false
      @adapter.write(flag.to_sym, data)
    end

    def delete(flag)
      validate_flag_exists!(flag)
      @adapter.delete(flag.to_sym)
    end

    def registered?(flag)
      @adapter.read(flag.to_sym) ? true : false
    end

    def all_flags
      @adapter.all
    end

    private

    def validate_flag_name!(name)
      raise ArgumentError, "Flag name cannot be nil" if name.nil?
      raise ArgumentError, "Flag name must be a string or symbol" unless name.is_a?(String) || name.is_a?(Symbol)
      raise ArgumentError, "Flag name cannot be empty" if name.to_s.strip.empty?
    end

    def validate_flag_exists!(flag)
      raise KeyError, "Flag '#{flag}' is not registered" unless registered?(flag)
    end
  end
end
