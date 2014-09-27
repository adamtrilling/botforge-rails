class BaseModel
  extend ActiveModel::Naming
  include ActiveModel::Model

  attr_reader :id

  class << self
    def attribute(name, params = {})
      define_method name.to_sym do
        @attributes ||= Hash.new
        @attributes[name]
      end

      define_method :"#{name}=" do |new_val|
        @attributes ||= Hash.new
        @attributes[name] = new_val
      end
    end

    def find(id)
      if (redis.exists("#{model_key}:#{id}"))
        new(redis.hgetall("#{model_key}:#{id}"))
      else
        nil
      end
    end
  end

  def persisted?
    @id.present?
  end

  def save
    @id = redis.incr("#{model_key}:next_id")
    redis.mapped_hmset(object_key, @attributes)
  end

  protected
  def self.redis
    @redis ||= Redis.new(Rails.application.config_for('redis'))
  end

  def redis
    self.class.redis
  end

  def self.model_key
    self.name
  end

  def model_key
    self.class.name
  end

  def object_key
    "#{model_key}:#{@id}"
  end
end