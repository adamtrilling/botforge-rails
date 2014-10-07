class BaseModel
  extend ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Dirty

  attr_accessor :id

  class << self
    def attribute(name, params = {})
      define_attribute_method name
      define_accessors(name)

      case params[:index]
      when :unique
        unless (has_unique_index?(name))
          create_unique_index(name)
        end
      when true
        unless (has_index?(name))
          create_index(name)
        end
      else

      end
    end

    def create(attrs = {})
      new_obj = new(attrs)
      new_obj.save
      new_obj
    end

    def all
      redis.smembers("#{model_key}:all").collect do |m|
        find(m)
      end
    end

    def find(id)
      if (redis.exists("#{model_key}:#{id}"))
        found = new(redis.hgetall("#{model_key}:#{id}"))
        found.id = id.to_i
        found
      else
        nil
      end
    end

    def find_by(params = {})
      raise ArgumentError if params.keys.size != 1

      search_key = params.keys.first

      if (has_index?(search_key))
        if (has_unique_index?(search_key))
          result = redis.hget("#{model_key}:indexes:#{search_key}", params[search_key])
          if (result)
            [find(result)]
          else
            []
          end
        else
          score = redis.hget("#{model_key}:indexes:#{search_key}:scores", params[search_key])
          results = redis.zrangebyscore("#{model_key}:indexes:#{search_key}:map", score, score)

          results.collect { |result_id| find(result_id) }
        end
      else
        raise UnindexedSearch
      end
    end
  end

  def persisted?
    @id.present?
  end

  def save
    @id ||= redis.incr("#{model_key}:next_id")
    redis.mapped_hmset(object_key, @attributes)

    # update indexes
    changes.each do |field, change|
      if (has_index?(field))
        if (has_unique_index?(field))
          redis.hdel("#{model_key}:indexes:#{field}", change.first) if change.first.present?
          redis.hset("#{model_key}:indexes:#{field}", change.last, @id)
        else
          redis.zrem("#{model_key}:indexes:#{field}:map", @id) if change.first.present?

          score = redis.hget("#{model_key}:indexes:#{field}:scores", change.last)
          unless (score)
            score = redis.incr("#{model_key}:indexes:#{field}:score_counter")
            redis.hset("#{model_key}:indexes:#{field}:scores", change.last, score)
          end
          redis.zadd("#{model_key}:indexes:#{field}:map", score, @id)
        end
      end
    end

    redis.sadd("#{model_key}:all", @id)
    changes_applied
    true
  end
  alias_method :save!, :save

  protected
  class << self
    def define_accessors(name)
      define_method name do
        @attributes ||= Hash.new
        @attributes[name]
      end

      define_method "#{name}=" do |new_val|
        @attributes ||= Hash.new
        send(:"#{name}_will_change!") unless new_val == @attributes[name]
        @attributes[name] = new_val
      end
    end

    def redis
      @redis ||= Redis.new(Rails.application.config_for('redis'))
    end

    def model_key
      self.name
    end

    def has_index?(key)
      redis.sismember("#{model_key}:indexes", key)
    end

    def has_unique_index?(key)
      redis.sismember("#{model_key}:unique_indexes", key)
    end

    def create_unique_index(key)
      redis.sadd("#{model_key}:unique_indexes", key)
      redis.sadd("#{model_key}:indexes", key)
      puts "creating unique index"
    end

    def create_index(key)
      redis.sadd("#{model_key}:indexes", key)
      puts "creating index"
    end
  end

  delegate :redis, :model_key, :has_index?, :has_unique_index?,
    to: :class

  def object_key
    "#{model_key}:#{@id}"
  end
end

class UnindexedSearch < Exception
end