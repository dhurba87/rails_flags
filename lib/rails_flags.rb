require "rails_flags/version"
require "rails_flags/engine"
require "rails_flags/configuration"

module RailsFlags
  class Error < StandardError; end
  class FlagNotRegisteredError < Error; end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def register(flag_name, **options)
      configuration.register(flag_name, **options)
    end

    def enabled?(flag)
      configuration.enabled?(flag)
    rescue KeyError => e
      raise FlagNotRegisteredError, e.message
    end

    def disabled?(flag)
      !enabled?(flag)
    end

    def enable(flag)
      configuration.enable(flag)
    rescue KeyError => e
      raise FlagNotRegisteredError, e.message
    end

    def disable(flag)
      configuration.disable(flag)
    rescue KeyError => e
      raise FlagNotRegisteredError, e.message
    end

    def registered?(flag)
      configuration.registered?(flag)
    end

    def all_flags
      configuration.all_flags
    end
  end
end
