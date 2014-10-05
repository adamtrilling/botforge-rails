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
      raise ArgumentError if params.keys.empty?

      if (redis.exists("#{model_key}:indexes:#{params.keys.first}"))
      else
        raise UnindexedSearch
      end
    end
  end

  def persisted?
    @id.present?
  end

  def save
    binding.pry
    @id ||= redis.incr("#{model_key}:next_id")
    redis.mapped_hmset(object_key, @attributes)
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
      redis.exists("#{model_key}:index:#{key}")
    end

    def has_unique_index?(key)
      redis.exists("#{model_key}:unique_index:#{key}")
    end

    def create_unique_index(key)
      puts "creating unique index"
    end

    def create_index(key)
      puts "creating index"
    end
  end

  def redis
    self.class.redis
  end

  def model_key
    self.class.name
  end

  def object_key
    "#{model_key}:#{@id}"
  end
end

class UnindexedSearch < Exception
end