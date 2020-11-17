require 'json'

# Caches and fetches values using Redis
class Cache
  attr_reader :redis

  def initialize
    @redis = Redis.new(AppConfig.instance.redis_config)
  end

  # @param [String] key
  # @param [] value - anything that responds to_json
  # @param [Integer] expire_minutes
  # @return [String, Boolean] value
  def store(key, value, expire_minutes = 60)
    redis.set(key, value.to_json, px: ms_timeout(expire_minutes))
  end

  # @param [String] key
  # @return [String]
  def get(key)
    redis.get(key)
  end

  # Fetches from redis or sets if key doesn't exist from value or yielded block
  #   Returns the fetched or set value
  # @param [String] key
  # @param [] value - anything that responds to_json
  # @param [Integer] expire_minutes
  # @return [String] value
  def fetch(key, value = nil, expire_minutes = 60)
    raise ArgumentError('Value or block is required') if !value && !block_given?

    current_value = redis.get(key)

    return current_value if current_value

    new_value = block_given? ? yield : value
    raise ArgumentError.new('No value given') unless new_value

    redis.set(key, new_value.to_json, px: ms_timeout(expire_minutes))
    new_value
  end

  # Deletes existing value from redis and sets new one.
  # @param [String] key
  # @param [] value - anything that responds to_json
  # @param [Integer] expire_minutes
  # @return [String] value
  def fetch!(key, value = nil, expire_minutes = 60)
    redis.del(key)
    new_value = if block_given?
                  yield
                else
                  value
                end
    redis.set(key, new_value.to_json, px: ms_timeout(expire_minutes))
    new_value
  end

  private

  def ms_timeout(after_minutes)
    now = Time.now.utc
    seconds = after_minutes * 60
    (now + seconds).to_i
  end
end
