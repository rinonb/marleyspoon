require 'json'

class Cache
  attr_reader :redis

  def initialize
    @redis = Redis.new
  end

  def store(key, value, expire_minutes = 60)
    redis.set(key, value.to_json, px: ms_timeout(expire_minutes))
  end

  def get(key)
    redis.get(key)
  end

  def fetch(key, value = nil, expire_minutes = 60)
    if !value && !block_given?
      raise ArgumentError.new('Value or block is required')
    end

    current_value = Redis.get(key)

    if current_value
      current_value
    else
      new_value = if block_given?
                    yield
                  else
                    value
                  end
      redis.set(key, new_value.to_json, px: ms_timeout(expire_minutes))
      new_value
    end
  end

  def fetch!(key, value = nil, timeout = 1.hour)
    redis.del(key)
    new_value = if block_given?
                  yield
                else
                  value
                end
    redis.set(key, new_value.to_json, px: ms_timeout(timeout))
    new_value
  end

  private

  def ms_timeout(after_minutes)
    now = Time.now.utc
    seconds = after_minutes * 60
    (now + seconds).to_i
  end
end
