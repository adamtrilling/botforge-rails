module Concerns::BaseModel::Indexing
  extend ActiveSupport::Concern

  included do
    delegate :has_index?, :has_unique_index?, :has_nonunique_index?,
      to: :class
  end

  module ClassMethods
    def has_index?(key)
      redis.sismember("#{model_key}:indexes", key)
    end

    def has_unique_index?(key)
      redis.sismember("#{model_key}:unique_indexes", key)
    end

    def has_nonunique_index?(key)
      has_index?(key) && !has_unique_index?(key)
    end

    def create_unique_index(key)
      redis.sadd("#{model_key}:unique_indexes", key)
      redis.sadd("#{model_key}:indexes", key)
    end

    def create_index(key)
      redis.sadd("#{model_key}:indexes", key)
    end
  end

  protected
  def _update_index(field, change)
    if (has_unique_index?(field))
      _update_unique_index(field, change)
    elsif (has_nonunique_index?(field))
      _update_nonunique_index(field, change)
    end
  end

  def _update_unique_index(field, change)
    redis.hdel("#{model_key}:indexes:#{field}", change.first) if change.first.present?
    redis.hset("#{model_key}:indexes:#{field}", change.last, @id)
  end

  def _update_nonunique_index(field, change)
    redis.zrem("#{model_key}:indexes:#{field}:map", @id) if change.first.present?

    score = redis.hget("#{model_key}:indexes:#{field}:scores", change.last)
    unless (score)
      score = redis.incr("#{model_key}:indexes:#{field}:score_counter")
      redis.hset("#{model_key}:indexes:#{field}:scores", change.last, score)
    end
    redis.zadd("#{model_key}:indexes:#{field}:map", score, @id)
  end
end