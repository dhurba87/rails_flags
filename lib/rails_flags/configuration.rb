module RailsFlags
  class Configuration
    def initialize
      @features = {}
    end

    def register(name, enabled: false, description: nil)
      validate_flag_name!(name)
      @features[name.to_sym] = {
        enabled: enabled,
        description: description,
        created_at: Time.now
      }
    end

    def enabled?(flag)
      validate_flag_exists!(flag)
      @features.dig(flag.to_sym, :enabled) == true
    end

    def enable(flag)
      validate_flag_exists!(flag)
      @features[flag.to_sym][:enabled] = true
    end

    def disable(flag)
      validate_flag_exists!(flag)
      @features[flag.to_sym][:enabled] = false
    end

    def registered?(flag)
      @features.key?(flag.to_sym)
    end

    def all_flags
      @features.transform_values { |v| v[:enabled] }
    end

    private

    def validate_flag_name!(name)
      raise ArgumentError, "Flag name must be a String or Symbol" unless name.is_a?(String) || name.is_a?(Symbol)
      raise ArgumentError, "Flag name cannot be empty" if name.to_s.strip.empty?
    end

    def validate_flag_exists!(flag)
      raise KeyError, "Flag '#{flag}' is not registered" unless registered?(flag)
    end
  end
end
