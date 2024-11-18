require 'redis'
require 'json'
require_relative 'base'

module RailsFlags
  module Adapters
    class RedisAdapter < Base
      REDIS_KEY_PREFIX = 'rails_flags:'.freeze

      def initialize(redis: nil, **redis_config)
        @redis = redis || Redis.new(redis_config)
      end

      def read(flag)
        data = @redis.get(key_for(flag))
        return nil unless data

        JSON.parse(data, symbolize_names: true)
      end

      def write(flag, value)
        @redis.set(key_for(flag), value.to_json)
      end

      def delete(flag)
        @redis.del(key_for(flag))
      end

      def all
        keys = @redis.keys("#{REDIS_KEY_PREFIX}*")
        return {} if keys.empty?

        values = @redis.mget(keys)
        keys.zip(values).each_with_object({}) do |(key, value), hash|
          flag_name = key.sub(REDIS_KEY_PREFIX, '').to_sym
          hash[flag_name] = JSON.parse(value, symbolize_names: true) if value
        end
      end

      def clear
        keys = @redis.keys("#{REDIS_KEY_PREFIX}*")
        @redis.del(keys) unless keys.empty?
      end

      private

      def key_for(flag)
        "#{REDIS_KEY_PREFIX}#{flag}"
      end
    end
  end
end
