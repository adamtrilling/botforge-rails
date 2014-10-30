class BaseModel
  extend ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Dirty

  include Concerns::BaseModel::Finders
  include Concerns::BaseModel::Indexing

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
  end

  def persisted?
    @id.present?
  end

  def save
    @id ||= redis.incr("#{model_key}:next_id")
    redis.mapped_hmset(object_key, @attributes)

    # update indexes
    changes.each do |field, change|
      _update_index(field, change)
    end

    redis.sadd("#{model_key}:all", @id)
    changes_applied
    true
  end
  alias_method :save!, :save

  def destroy
    redis.del(object_key)
    redis.srem("#{model_key}:all", @id)

    @attributes.each do |field, val|
      if (has_index?(field))
        if (has_unique_index?(field))
          redis.hdel("#{model_key}:indexes:#{field}", val)
        else
          redis.zrem("#{model_key}:indexes:#{field}:map", @id)
        end
      end
    end

    self
  end

  def self.destroy_all
    all.each do |obj|
      obj.destroy
    end
  end

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
  end

  delegate :redis, :model_key,
    to: :class

  def object_key
    "#{model_key}:#{@id}"
  end
end

class UnindexedSearch < Exception
end